import 'package:flutter/material.dart';

/// Responsive helpers (MediaQuery based).
bool isWide(BuildContext c) => MediaQuery.of(c).size.width >= 800;
int gridCols(BuildContext c) {
  final w = MediaQuery.of(c).size.width;
  return w >= 1100 ? 4 : (w >= 600 ? 2 : 1);
}

/// Centers content and limits width on large screens.
class Constrained extends StatelessWidget {
  final Widget child;
  const Constrained({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900), child: child),
      );
}

/// Reusable stat card used in the dashboard GridView.
class StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const StatCard(
      {super.key, required this.label, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: t.colorScheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, color: t.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: t.textTheme.bodySmall),
                  Text(value,
                      style: t.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ]),
          ),
        ]),
      ),
    );
  }
}

/// Reusable avatar with initial letter, stacked with a small badge.
class MemberAvatar extends StatelessWidget {
  final String name;
  final double? balance;
  const MemberAvatar({super.key, required this.name, this.balance});
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Stack(clipBehavior: Clip.none, children: [
      CircleAvatar(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          child: Text(name[0].toUpperCase())),
      if (balance != null)
        Positioned(
          right: -4,
          bottom: -4,
          child: Icon(balance! >= 0 ? Icons.arrow_circle_up : Icons.arrow_circle_down,
              size: 16, color: balance! >= 0 ? Colors.green[800] : Colors.red[800]),
        ),
    ]);
  }
}
