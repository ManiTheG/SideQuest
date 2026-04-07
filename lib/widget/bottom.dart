import 'package:flutter/material.dart';

class SharedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const SharedBottomNavigationBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = ['/home', '/search', '/profile'];
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 25, 36, 54),
      selectedItemColor: Color.fromARGB(255, 16, 103, 234),
      unselectedItemColor: Colors.white38,
      currentIndex: currentIndex,
      iconSize: 32, // <-- larger icons
      showSelectedLabels: false, // <-- hide labels
      showUnselectedLabels: false,
      onTap: (index) {
        final target = routes[index];
        final current = ModalRoute.of(context)?.settings.name;
        if (current == target) return;
        Navigator.pushReplacementNamed(context, target);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}