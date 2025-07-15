import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.greenAccent,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_outline),
          activeIcon: Icon(Icons.pie_chart),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          activeIcon: Icon(Icons.trending_up_outlined),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.app_settings_alt_outlined),
          activeIcon: Icon(Icons.app_settings_alt),
          label: 'Settings',
        ),
      ],
    );
  }
}
