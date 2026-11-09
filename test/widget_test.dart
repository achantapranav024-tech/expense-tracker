import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/state.dart';

void main() {
  group('ExpenseState', () {
    test('adds an expense and updates total', () {
      final state = ExpenseState();
      state.addExpense(Expense(
        'Lunch', 200, 'You', ['You', 'Member 2'], DateTime(2026, 1, 1),
      ));

      expect(state.total, 200);
      expect(state.expenses.length, 1);
    });

    test('calculates equal split balances', () {
      final state = ExpenseState();
      state.addExpense(Expense(
        'Dinner', 100, 'You', ['You', 'Member 2'], DateTime(2026, 1, 1),
      ));

      expect(state.balances['You'], 50);
      expect(state.balances['Member 2'], -50);
    });

    test('suggests the correct settlement', () {
      final state = ExpenseState();
      state.addExpense(Expense(
        'Dinner', 100, 'You', ['You', 'Member 2'], DateTime(2026, 1, 1),
      ));

      expect(state.settlements.length, 1);
      expect(state.settlements.first.from, 'Member 2');
      expect(state.settlements.first.to, 'You');
      expect(state.settlements.first.amount, 50);
    });
  });
}
