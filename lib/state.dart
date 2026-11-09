import 'package:flutter/foundation.dart';

class Expense {
  final String title, paidBy;
  final double amount;
  final List<String> sharedBy;
  final DateTime date;
  Expense(this.title, this.amount, this.paidBy, this.sharedBy, this.date);
}

class Transfer {
  final String from, to;
  final double amount;
  Transfer(this.from, this.to, this.amount);
}

/// App state managed with Provider (ChangeNotifier).
class ExpenseState extends ChangeNotifier {
  final List<String> members = ['You', 'Member 2'];
  final List<Expense> expenses = [];

  double get total => expenses.fold(0.0, (s, e) => s + e.amount);

  void addMember(String name) {
    members.add(name.trim());
    notifyListeners();
  }

  void addExpense(Expense e) {
    expenses.insert(0, e);
    notifyListeners();
  }

  void removeExpense(Expense e) {
    expenses.remove(e);
    notifyListeners();
  }

  void reset() {
    expenses.clear();
    notifyListeners();
  }

  /// Positive = should receive money, negative = owes money.
  Map<String, double> get balances {
    final b = {for (final m in members) m: 0.0};
    for (final e in expenses) {
      final share = e.amount / e.sharedBy.length;
      b[e.paidBy] = (b[e.paidBy] ?? 0) + e.amount;
      for (final p in e.sharedBy) {
        b[p] = (b[p] ?? 0) - share;
      }
    }
    return b;
  }

  /// Greedy settlement: who pays whom to clear all debts.
  List<Transfer> get settlements {
    final cr = <MapEntry<String, double>>[], db = <MapEntry<String, double>>[];
    balances.forEach((k, v) {
      if (v > 0.01) cr.add(MapEntry(k, v));
      if (v < -0.01) db.add(MapEntry(k, -v));
    });
    final out = <Transfer>[];
    int i = 0, j = 0;
    while (i < db.length && j < cr.length) {
      final amt = db[i].value < cr[j].value ? db[i].value : cr[j].value;
      out.add(Transfer(db[i].key, cr[j].key, amt));
      db[i] = MapEntry(db[i].key, db[i].value - amt);
      cr[j] = MapEntry(cr[j].key, cr[j].value - amt);
      if (db[i].value < 0.01) i++;
      if (cr[j].value < 0.01) j++;
    }
    return out;
  }
}
