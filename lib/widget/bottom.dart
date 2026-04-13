import 'package:flutter/material.dart';
import 'package:sidequest/screens/search.dart';
import 'package:sidequest/services/color_service.dart';
import '../screens/home_screen.dart';
import '../screens/search.dart';
import '../screens/profile.dart';

class SharedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const SharedBottomNavigationBar({Key? key, required this.currentIndex}) : super(key: key);

  Widget _getScreen(int index) {
    switch (index) {
      case 0: return const HomeScreen();
      case 1: return const SearchPage();
      case 2: return const ProfilePage(
          userName: 'John Doe',
          userBio: 'Flutter enthusiast and adventurer.',
          userInterests: [],
          userPosts: [],
      );
      default: return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes = ['/home', '/search', '/profile'];
    return BottomNavigationBar(
      backgroundColor: AppColors.secondary,
      selectedItemColor: AppColors.buttonColor,
      unselectedItemColor: AppColors.unselectButtonColor,
      currentIndex: currentIndex,
      iconSize: 32,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        final target = routes[index];
        final current = ModalRoute.of(context)?.settings.name;
        if (current == target) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            settings: RouteSettings(name: target),
            pageBuilder: (context, animation, secondaryAnimation) => _getScreen(index),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
  final darkFade = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ),
  );
  final scale = Tween<double>(begin: 0.95, end: 1.0).animate(
    CurvedAnimation(
      parent: animation,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ),
  );
  final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animation,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    ),
  );

  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) {
      return Stack(
        children: [
          FadeTransition(
            opacity: fadeIn,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          ),
          if (animation.value < 0.5)
            Opacity(
              opacity: darkFade.value,
              child: Container(
                color: Colors.black,
              ),
            ),
        ],
      );
    },
  );
},
transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}