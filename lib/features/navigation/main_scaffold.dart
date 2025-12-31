// lib/features/navigation/main_scaffold.dart
import 'package:expense_tracker/core/widgets/bottom_nav_bar.dart';
import 'package:expense_tracker/features/budget/presentation/create_budget.dart';
import 'package:expense_tracker/features/expenses/presentation/pages/exp_page.dart';
import 'package:expense_tracker/features/home/presentation/home_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ExpensesPage(),
    //BudgetPage(),
    CreateBudgetPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
