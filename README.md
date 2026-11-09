# Expense Tracker

A responsive Flutter web application for recording shared group expenses, managing members, viewing net balances, and calculating suggested settlements.

## Features
- Add shared expenses with description, amount, payer, and participants.
- Add members with blank-name and duplicate-name validation.
- View total spending, number of expenses, and member count.
- View each member's balance and suggested settlement transfers.
- Swipe left on an expense to delete it.
- Reset expense records using the settle-up action.
- Responsive navigation: NavigationRail on wide screens and NavigationBar on smaller screens.
- Animated splash screen and animated page switching.
- Reusable widgets and Material 3 theme.

## Technologies
Flutter, Dart, Provider (ChangeNotifier), Material 3, Git, GitHub Pages.

## Run locally
```powershell
flutter pub get
flutter run -d chrome
```

## Build for GitHub Pages
The repository name is `expense-tracker`, so the base path must match:
```powershell
flutter build web --release --base-href "/expense-tracker/" --output docs
```

## Publish
1. Create a public GitHub repository named `expense-tracker`.
2. Push the complete project including the generated `docs` folder to the `main` branch.
3. Open repository Settings > Pages.
4. Select **Deploy from a branch**, branch **main**, folder **/docs**, then Save.
5. The public URL will be `https://YOUR_USERNAME.github.io/expense-tracker/`.

## Current data limitation
The current version stores members and expenses in Provider memory only. Data resets when the page is refreshed or the app is restarted. Persistent storage or a cloud database can be added as a future enhancement.

## Project documentation
See `Expense_Tracker_Documentation_Report.docx` in the submission materials for the report template, code explanations, testing checklist, and screenshot placeholders.
