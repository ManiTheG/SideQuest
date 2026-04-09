import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

import 'package:sidequest/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}


class _SignupScreenState extends State<SignupScreen>{
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final passNotifier = ValueNotifier<PasswordStrength?>(null);
  bool _isLoading = false;
  String? _errorMessage;

  //lista će zasad biti definirana ovdje

  final List<String> _allInterests = 
  ['plaseholder1','plaseholder2','plaseholder3',
  'plaseholder4','plaseholder5','plaseholder6'];

//odair korisnika barem jedan mora biti
  final List<String> _userInterests = [];

  @override
  void dispose(){
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _selectToggle(String interest){
    setState(() {
      if(_userInterests.contains(interest)){
        _userInterests.remove(interest);
      }else{
        _userInterests.add(interest);
      }
    });
  }

  Future<void> _signUp () async{

    if(_userNameController.text.isEmpty || _emailController.text.isEmpty
     || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty){
        setState (() => _errorMessage = 'All field must me filled to continue');
        return;
     }

  
    if (!EmailValidator.validate(_emailController.text)) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      _emailController.clear();
      return;
    }

     if(!(_passwordController.text ==_confirmPasswordController.text)){
      setState(()=> _errorMessage = 'Passwords do not match!');
      return;
     }

     if(!(_passwordController.text.contains(RegExp(r'[a-z]')) && _passwordController.text.contains(RegExp(r'[A-Z]'))
     && _passwordController.text.contains(RegExp(r'[0-9]')) && _passwordController.text.contains(RegExp(r'["$&+,:;=?@#|<>.^*()%!-]')))){
      setState(()=> _errorMessage = 'Password must contain at least one: \nlowercase letter\nuppercae letter\nnumber\nspecial character');
      return;
     }

     if(_passwordController.text.length<6){
      setState(()=> _errorMessage = 'Password must be at least 6 characters long');
      return;
     }

     if(_userInterests.isEmpty){
      setState(()=> _errorMessage = 'Please select at least one interest');
      return;
     }


     setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try{
      UserCredential userCred = await _authService.signUp(
        _emailController.text,
        _passwordController.text,
        );
              
      try{
      await firestoreSideQuest.collection('users').doc(userCred.user!.uid).set(
        {
          'username': _userNameController.text.trim(),
          'email': _emailController.text.trim(),
          'interests': _userInterests,
          'created': FieldValue.serverTimestamp(),
        },
        //userCred.displayName = _userNameController.text.trim()
        ).timeout( Duration(seconds: 10 ), onTimeout: ()=> throw Exception('Request timed out. please try again'));
      }catch(e){
        await userCred.user?.delete();
        setState(() => _errorMessage = 'Failed to save user data');
      }

      if(mounted){
        Navigator.of(context).pop();
      }

    }catch(e){
      setState(()=> _errorMessage = e.toString());
    }finally{
      setState(() => _isLoading = false);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      //resizeToAvoidBottomInset: true,
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 16, 24, 40), Color.fromARGB(255, 29, 52, 97)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 16, 103, 234),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(),
                    ),
                  ),
                ),
              ),

              Text('Sign Up', style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),

              const SizedBox(height:35),
              //koisnicko ime
              TextField(
                controller: _userNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Color.fromARGB(255, 55, 73, 87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                    ),
                  ),
                //style: TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 16),
              //email
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Color.fromARGB(255, 55, 73, 87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                    ),
                  ),
                keyboardType: TextInputType.emailAddress
              ),
              const SizedBox(height: 16),
              //loinka/zaporka
        
              //lozinka
            /*  TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Color.fromARGB(255, 55, 73, 87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                    ),
                ),
                obscureText: true,
                onChanged: (value){ passNotifier.value = PasswordStrength.calculate(text: _passwordController.text);},
              ),*/
              const SizedBox(height: 16),

              TextField(
                controller: _confirmPasswordController,
                style: TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  labelText: 'Confirm password',
                  labelStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Color.fromARGB(255, 55, 73, 87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                    ),
                  ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              
              /*PasswordStrengthFormChecker(
                minimumStrengthRequired: PasswordStrength.strong,
                onChanged: (_passwordController.text, passNotifier){passNotifier.value = PasswordStrength.calculate(text: _passwordController.text);},
                
                ),*/

              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _errorMessage != null
                  ? Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),  // light red background
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.4)), // subtle red border
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              ),

              const SizedBox(height: 12),

              //lista hobbija
              const Text('Select your interests:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height:16),
        
        
              //tipkice za interes
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: _allInterests.map((interest){
                  final isSelected = _userInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest, style: TextStyle(color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(179, 255, 255, 255))),
                    selected: isSelected,
                    onSelected: (_) => _selectToggle(interest),
                    backgroundColor: Color.fromARGB(255, 55, 73, 87),
                    selectedColor: Color.fromARGB(255, 16, 103, 234),
                    checkmarkColor: Colors.white,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height:24),
        
              _isLoading? const Center (child: CircularProgressIndicator())
              : ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 16, 103, 234),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                elevation: 4,
                shadowColor: Color(0xFF6C63FF).withValues(alpha: 0.4)
              ),
                child: const Text('Sign up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ),
        
              //povratak na login
              TextButton(
                onPressed: () => Navigator.pop(context), 
                style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                alignment: Alignment.center,
                ),
                child: const Text('Already have an account? Login'))
            ],
          ),
        ),
      )
    );
  }
}

