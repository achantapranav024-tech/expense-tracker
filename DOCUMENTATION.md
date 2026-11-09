# Expense Tracker – Project Documentation

**Application:** Expense Tracker  
**Technology:** Flutter Web, Dart, Provider  
**Deployment platform:** GitHub Pages  
**Student name:** ______________________________  
**Roll number:** ______________________________  
**Class / section:** ____________________________  

## 1. Application name and introduction
Expense Tracker is a responsive Flutter web application for managing expenses shared among a group. Users can record expenses, select who paid and who shares each expense, view each member's net balance, and see suggested settlement transfers.

## 2. Purpose and objectives
- Record shared group expenses in one place.
- Manage group members.
- Calculate net balances automatically.
- Suggest who should pay whom to settle outstanding balances.
- Demonstrate core Flutter laboratory concepts in a working application.

## 3. Tools and technologies
- **Flutter:** UI framework for building the web application.
- **Dart:** Programming language.
- **Provider:** State management using ChangeNotifier.
- **Material 3:** Consistent application theme and UI components.
- **Visual Studio Code:** Code editor.
- **Chrome:** Local browser testing.
- **Git and GitHub Pages:** Version control and hosting.

## 4. Features and functionalities
1. Animated splash screen.
2. Expenses dashboard showing total spent, expense count, and member count.
3. Add Expense form with description, amount, payer, and split participants.
4. Form validation for description and positive numeric amount.
5. Members screen with add-member validation, including duplicate-name prevention.
6. Balances screen showing positive and negative member balances.
7. Settlement calculation showing who pays whom.
8. Swipe-to-delete for expense entries.
9. Settle up and reset action.
10. Responsive navigation: NavigationRail on wide screens and NavigationBar on smaller screens.
11. About screen and named-route navigation.

## 5. Important code snippets

### Provider state management
```dart
class ExpenseState extends ChangeNotifier {
  final List<String> members = ['You', 'Member 2'];
  final List<Expense> expenses = [];

  void addExpense(Expense e) {
    expenses.insert(0, e);
    notifyListeners();
  }
}
```

### Responsive layout
```dart
bool isWide(BuildContext c) =>
    MediaQuery.of(c).size.width >= 800;
```

### Form validation
```dart
validator: (v) {
  final n = double.tryParse(v ?? '');
  if (n == null) return 'Enter a valid number';
  if (n <= 0) return 'Amount must be greater than 0';
  return null;
}
```

### Named route navigation
```dart
'/home' => const HomeScreen(),
'/add' => const AddExpenseScreen(),
'/about' => const AboutScreen(),
```

### Animation
The splash screen uses AnimationController, FadeTransition, and ScaleTransition. The home screen uses AnimatedSwitcher to animate page changes.

### Reusable widgets
StatCard, MemberAvatar, and Constrained are reusable custom widgets. The application also uses Container, Row, Column, Stack, ListView, GridView, Card, buttons, chips, and form widgets.

## 6. Deployment details
The application is built for GitHub Pages with the repository-specific base path:
```powershell
flutter build web --release --base-href "/expense-tracker/" --output docs
```
The generated `docs` folder is published from the `main` branch using GitHub Pages settings (**Settings > Pages > Deploy from a branch > main > /docs**).

**Live URL:** https://YOUR_USERNAME.github.io/expense-tracker/  
Replace YOUR_USERNAME with the GitHub account username after deployment.

## 7. Screenshots of UI output
Insert actual screenshots from the running application:
- Figure 1 – Splash screen
- Figure 2 – Expenses dashboard (desktop)
- Figure 3 – Add Expense form and validation
- Figure 4 – Members screen
- Figure 5 – Balances and settlement screen
- Figure 6 – Mobile responsive layout
- Figure 7 – About screen / deployed website

## 8. Testing checklist
- Add an expense and verify that the total updates.
- Reject blank/short descriptions and invalid, zero, or negative amounts.
- Add a member and verify duplicate-name validation.
- Split an expense among selected members and check the resulting balances.
- Delete an expense and verify that totals update.
- Test navigation and layouts at mobile, tablet, and desktop widths.
- Open the deployed link in an incognito browser window.

Automated verification performed during preparation:
- `flutter analyze`: no issues found.
- `flutter test`: all 5 tests passed (3 expense-state tests and 2 responsive-layout tests).
- `flutter build web --release --base-href "/expense-tracker/" --output docs`: completed successfully.

## 9. Limitations and future enhancements
The current app stores member and expense data in Provider memory only. Data resets after a page refresh or application restart. Future improvements may include local or cloud persistence, authentication, expense categories, monthly reports, and PDF/CSV export.

## 10. Conclusion
Expense Tracker demonstrates a responsive and interactive Flutter application using widgets, responsive layouts, navigation, animations, Provider state management, reusable custom widgets, and validated forms.
