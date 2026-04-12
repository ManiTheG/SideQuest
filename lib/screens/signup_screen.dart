import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sidequest/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sidequest/services/color_service.dart';
import 'package:sidequest/services/db_read_service.dart';
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
  final InterestsService _interestsService = InterestsService();
  //final InterestsServices _interestsService = InterestsServices();
  double _passStrength = 0;
  bool _isLoading = false;
  String? _errorMessage;

  //lista će zasad biti definirana ovdje

  List<String> _allInterests = [];

//odair korisnika barem jedan mora biti
  final List<String> _userInterests = [];

  @override
  void initState() {
    super.initState();
    _loadAllInterests();
  }

  Future<void> _loadAllInterests() async{
    final interests = await _interestsService.loadAllInterests();
   
    setState(() => _allInterests = interests);
  }

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

  bool _passValidation(String password){
    String pass = password.trim();
    if(pass.isEmpty){ setState(() =>  _passStrength = 0);}
    else if(pass.length < 6) {setState(() =>  _passStrength = 1/5);}
    else if(pass.length < 12) {setState(() =>  _passStrength = 2/4);}
    else if(pass.length < 15) {setState(() =>  _passStrength = 3/4);}
    else {
      if((RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*["$&+,:;=?@#|<>.^*()%!-]).*$')).hasMatch(pass)){
        setState(() =>  _passStrength = 1);
        return true;
      }else{
        setState(() =>  _passStrength = 3/4);
        return false;
      }

    }
    return false;
  }



  Future<void> _signUp () async{

    if(_userNameController.text.isEmpty || _emailController.text.isEmpty
     || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty){
        setState (() => _errorMessage = 'All field must me filled to continue');
        return;
     }

  
    if (!EmailValidator.validate(_emailController.text)) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      _emailController.clear();
      return;
    }

    if(!(_passwordController.text ==_confirmPasswordController.text)){
      setState(()=> _errorMessage = 'Passwords do not match!');
      return;
    }

    if(_passStrength<3/4){
      setState(() => _errorMessage = 'Password is not strong enough!');
      return;
    }

    if(!(_passwordController.text.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*["$&+,:;=?@#|<>.^*()%!-]).*$')))){
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
          child: Form(
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
                inputFormatters: [LengthLimitingTextInputFormatter(64)],
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
                inputFormatters: [LengthLimitingTextInputFormatter(254)],
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
              
              //lozinka

              TextFormField(
                  controller: _passwordController,
                  inputFormatters: [LengthLimitingTextInputFormatter(128)],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0),
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
                  onChanged: (value){
                    _passValidation(value);
                  },
                  validator: (value){
                    if (!_passValidation(value ?? '')) {
                      return 'Password is not strong enough';
                    }
                    return null;
                  },

              ),

              const SizedBox(height: 16),

              TextField(
                controller: _confirmPasswordController,
                inputFormatters: [LengthLimitingTextInputFormatter(128)],
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

              const SizedBox(height: 16),

              TweenAnimationBuilder<double>(
                tween: Tween<double>(end: _passStrength),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut, 
                builder: (context, value, _){
                  return LinearProgressIndicator(
                    value:value,
                    backgroundColor: Colors.white,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(30),
                    color: strengthColor(value),
                  );
                },
              ),

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
        ),
      ),
    );
  }
}

