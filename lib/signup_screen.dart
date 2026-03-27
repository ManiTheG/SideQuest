import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen>{
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); 
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
      appBar: AppBar(title: const Text("Signup")),
      body: const Center(child: Text("Welcome to the Signup Screen!")),
    );
  }
}

