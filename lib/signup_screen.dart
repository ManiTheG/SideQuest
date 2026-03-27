import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

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

    //bool isValidEmail = .hasMatch(_emailController.te);

     if(!(_emailController.text.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))){
      setState(()=> _errorMessage = 'Not a valit email');
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
        _passwordController.text
        );

      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set(
        {
          'username': _userNameController.text.trim(),
          'email': _emailController.text.trim(),
          'interests': _userInterests,
          'created': FieldValue.serverTimestamp(),
        });

    }catch(e){
      setState(()=> _errorMessage = e.toString());
    }finally{
      _isLoading = false;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
      centerTitle: true,
      title: const Text('Sign up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            //koisnicko ime
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'Username'),
              //style: TextStyle(fontSize: 10),
            ),
            const SizedBox(height: 16),
            //email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress
            ),
            const SizedBox(height: 16),
            //loinka/zaporka

            //lozinka
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            //ponavljanje lozinke
            TextField(
              controller: _confirmPasswordController,
              decoration:  const InputDecoration(labelText: 'Please confim password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            //lista hobbija
            const Text('Select your interests:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                  label: Text(interest), 
                  selected: isSelected,
                  onSelected: (_) => _selectToggle(interest),
                );
              }).toList(),
            ),
            const SizedBox(height:24),


            if (_errorMessage != null)...[
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
            ],

            _isLoading? const Center (child: CircularProgressIndicator())
            : ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign up')
            ),

            //povratak na login
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Already have an account? Login'))
          ],
        ),
      )
    );
  }
}

