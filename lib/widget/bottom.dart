import 'package:flutter/material.dart';
import 'package:sidequest/services/color_service.dart';

class SharedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const SharedBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final routes = ['/home', '/search', '/profile'];
    return BottomNavigationBar(
      backgroundColor: AppColors.secondary,
      selectedItemColor: AppColors.buttonColor,
      unselectedItemColor: AppColors.unselectButtonColor,
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
