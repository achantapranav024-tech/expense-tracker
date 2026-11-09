import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'state.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (_) => ExpenseState(), child: const ExpenseTrackerApp()));

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      // Consistent app theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
        cardTheme: CardThemeData(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        inputDecorationTheme:
            const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      initialRoute: '/',
      // Named routes with custom slide transition
      onGenerateRoute: (s) {
        final Widget page = switch (s.name) {
          '/home' => const HomeScreen(),
          '/add' => const AddExpenseScreen(),
          '/about' => const AboutScreen(),
          _ => const SplashScreen(),
        };
        return PageRouteBuilder(
          settings: s,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, a, __, child) => SlideTransition(
              position: Tween(begin: const Offset(0, .08), end: Offset.zero)
                  .animate(CurvedAnimation(parent: a, curve: Curves.easeOut)),
              child: FadeTransition(opacity: a, child: child)),
        );
      },
    );
  }
}
