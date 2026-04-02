import 'package:flutter/material.dart';

class SharedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const SharedBottomNavigationBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = ['/home', '/search', '/profile'];
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final target = routes[index];
        final current = ModalRoute.of(context)?.settings.name;
        if (current == target) return;
        Navigator.pushReplacementNamed(context, target);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}