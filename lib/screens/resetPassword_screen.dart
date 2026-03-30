import 'package:flutter/material.dart';
import 'package:sidequest/main.dart';
import 'package:sidequest/screens/signup_screen.dart';
import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>{
  final _emailController  = TextEditingController();
  final AuthService _auth =AuthService();
  bool isLoading = false;
  String? _errorMessage;

  @override
  void dipose(){
    _emailController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context){
    return Scaffold(
    resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 16, 24, 40), Color.fromARGB(255, 29, 52, 97)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(

        ),
        ),
      ),
    );
  }
}