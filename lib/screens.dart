import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';
import 'widgets.dart';

// ---------- Splash (animation) ----------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
        ..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: FadeTransition(
          opacity: _c,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.groups_2, size: 90, color: cs.onPrimary),
              const SizedBox(height: 12),
              Text('Expense Tracker',
                  style: TextStyle(
                      color: cs.onPrimary, fontSize: 26, fontWeight: FontWeight.bold)),
              Text('Split bills. Stay friends.',
                  style: TextStyle(color: cs.onPrimary.withValues(alpha: .8))),
            ]),
          ),
        ),
      ),
    );
  }
}

// ---------- Home (responsive shell) ----------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _i = 0;
  static const _pages = [ExpensesPage(), BalancesPage(), MembersPage()];
  static const _items = [
    (Icons.receipt_long, 'Expenses'),
    (Icons.balance, 'Balances'),
    (Icons.people, 'Members'),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
              tooltip: 'About',
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.pushNamed(context, '/about')),
        ],
      ),
      body: Row(children: [
        if (wide)
          NavigationRail(
            selectedIndex: _i,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (v) => setState(() => _i = v),
            destinations: [
              for (final it in _items)
                NavigationRailDestination(icon: Icon(it.$1), label: Text(it.$2))
            ],
          ),
        Expanded(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(key: ValueKey(_i), child: _pages[_i]))),
      ]),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _i,
              onDestinationSelected: (v) => setState(() => _i = v),
              destinations: [
                for (final it in _items)
                  NavigationDestination(icon: Icon(it.$1), label: it.$2)
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/add'),
          icon: const Icon(Icons.add),
          label: const Text('Add Expense')),
    );
  }
}

// ---------- Expenses page (GridView + ListView) ----------
class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<ExpenseState>();
    return Constrained(
      child: ListView(padding: const EdgeInsets.all(16), children: [
        GridView.count(
          crossAxisCount: gridCols(context),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            StatCard(
                label: 'Total spent',
                value: '₹${s.total.toStringAsFixed(2)}',
                icon: Icons.currency_rupee),
            StatCard(
                label: 'Expenses', value: '${s.expenses.length}', icon: Icons.receipt),
            StatCard(label: 'Members', value: '${s.members.length}', icon: Icons.group),
          ],
        ),
        const SizedBox(height: 16),
        Text('Recent expenses', style: Theme.of(context).textTheme.titleMedium),
        if (s.expenses.isEmpty)
          const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('No expenses yet. Tap "Add Expense".'))),
        for (final e in s.expenses)
          Dismissible(
            key: ObjectKey(e),
            background: Container(
                color: Colors.red[200],
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete)),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => s.removeExpense(e),
            child: Card(
              child: ListTile(
                leading: MemberAvatar(name: e.paidBy),
                title: Text(e.title),
                subtitle: Text(
                    'Paid by ${e.paidBy} • split ${e.sharedBy.length} ways'),
                trailing: Text('₹${e.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ]),
    );
  }
}

// ---------- Balances page ----------
class BalancesPage extends StatelessWidget {
  const BalancesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<ExpenseState>();
    final t = s.settlements;
    return Constrained(
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Each member\'s balance', style: Theme.of(context).textTheme.titleMedium),
        for (final m in s.balances.entries)
          Card(
            child: ListTile(
              leading: MemberAvatar(name: m.key, balance: m.value),
              title: Text(m.key),
              trailing: Text(
                  '${m.value >= 0 ? '+' : '-'}₹${m.value.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: m.value >= 0 ? Colors.green[800] : Colors.red[800])),
            ),
          ),
        const SizedBox(height: 16),
        Text('Who pays whom', style: Theme.of(context).textTheme.titleMedium),
        if (t.isEmpty)
          const Padding(
              padding: EdgeInsets.all(24), child: Center(child: Text('All settled! 🎉'))),
        for (final x in t)
          Card(
            child: ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text('${x.from} pays ${x.to}'),
              trailing: Text('₹${x.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
            onPressed: s.expenses.isEmpty ? null : s.reset,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Settle up & reset')),
      ]),
    );
  }
}

// ---------- Members page (form in dialog) ----------
class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  void _add(BuildContext context) {
    final s = context.read<ExpenseState>();
    final key = GlobalKey<FormState>();
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add member'),
        content: Form(
          key: key,
          child: TextFormField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) {
              final n = v?.trim() ?? '';
              if (n.isEmpty) return 'Name is required';
              if (s.members.any((m) => m.toLowerCase() == n.toLowerCase())) {
                return 'Member already exists';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  s.addMember(ctrl.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<ExpenseState>();
    return Constrained(
      child: ListView(padding: const EdgeInsets.all(16), children: [
        for (final m in s.members)
          Card(child: ListTile(leading: MemberAvatar(name: m), title: Text(m))),
        const SizedBox(height: 8),
        FilledButton.icon(
            onPressed: () => _add(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Add member')),
      ]),
    );
  }
}

// ---------- Add Expense (validated form) ----------
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String? _payer;
  late Set<String> _shared;

  @override
  void initState() {
    super.initState();
    final m = context.read<ExpenseState>().members;
    _payer = m.first;
    _shared = {...m};
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    if (_shared.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select at least one person to split with')));
      return;
    }
    context.read<ExpenseState>().addExpense(Expense(_title.text.trim(),
        double.parse(_amount.text), _payer!, _shared.toList(), DateTime.now()));
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Expense added')));
  }

  @override
  Widget build(BuildContext context) {
    final members = context.watch<ExpenseState>().members;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Constrained(
        child: Form(
          key: _form,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                  labelText: 'Description', prefixIcon: Icon(Icons.edit)),
              validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Enter at least 3 characters' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Amount (₹)', prefixIcon: Icon(Icons.currency_rupee)),
              validator: (v) {
                final n = double.tryParse(v ?? '');
                if (n == null) return 'Enter a valid number';
                if (n <= 0) return 'Amount must be greater than 0';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _payer,
              decoration: const InputDecoration(
                  labelText: 'Paid by', prefixIcon: Icon(Icons.person)),
              items: [for (final m in members) DropdownMenuItem(value: m, child: Text(m))],
              onChanged: (v) => setState(() => _payer = v),
            ),
            const SizedBox(height: 16),
            const Text('Split between'),
            Wrap(spacing: 8, children: [
              for (final m in members)
                FilterChip(
                  label: Text(m),
                  selected: _shared.contains(m),
                  onSelected: (v) =>
                      setState(() => v ? _shared.add(m) : _shared.remove(m)),
                ),
            ]),
            const SizedBox(height: 24),
            FilledButton.icon(
                onPressed: _save, icon: const Icon(Icons.check), label: const Text('Save expense')),
          ]),
        ),
      ),
    );
  }
}

// ---------- About ----------
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('About')),
        body: const Constrained(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.groups_2, size: 72),
              SizedBox(height: 12),
              Text('Expense Tracker v1.0',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Add shared expenses, see balances and settle up easily.\nBuilt with Flutter & Provider.',
                  textAlign: TextAlign.center),
            ]),
          ),
        ),
      );
}
