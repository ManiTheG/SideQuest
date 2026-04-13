import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_options.dart';
import 'package:sidequest/screens/login_screen.dart';
import 'package:sidequest/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/search.dart';
import 'screens/profile.dart';


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
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'SideQuest',
      theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: false,
              ),
      home: StreamBuilder <User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          if(snapshot.hasData){
            return const HomeScreen(title: 'Mc2 Home');
          }
          return const LoginScreen();
        },
      ),
      routes: {
                '/home': (ctx) => const HomeScreen(title: 'SideQuest Home'),
                '/search': (ctx) => const SearchPage(),
                '/profile': (ctx) => const ProfilePage.preset(),
            },
    );
  }
  }


  /*citanje iz baze:
  final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .get();

List<String> interests = List<String>.from(doc['interests']);@*/
