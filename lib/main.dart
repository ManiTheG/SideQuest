// ...existing code...
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'widget/bottom.dart';
import 'search.dart';
import 'profile.dart';
import 'home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mc2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (ctx) => const MyHomePage(title: 'Mc2 Home'),
        '/search': (ctx) => const SearchPage(),
        '/profile': (ctx) => const ProfilePage.preset(),
      },
    );
  }
}