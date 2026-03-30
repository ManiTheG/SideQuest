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
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isShown = true;
  String? _errorMessage;

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  Future <void> _resetPassword() async{
    if(_emailController.text.isEmpty){
      setState(() => _errorMessage = 'Please enter your email to reset password.');
      _emailController.clear();
      return;
    }
    try{
      await _authService.resetPassword(_emailController.text);
      setState(()=> _errorMessage = 'Password reset email sent. Please check your inbox.');
    } catch(e){
      setState(() => _errorMessage = e.toString());
    }
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

        child: _isShown ? Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
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
            ),

             TextField(
              controller: _emailController,
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
              keyboardType: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: 16),
            
            _isLoading? const Center(child: CircularProgressIndicator())
            //gumb za poziv login funkcije
            : ElevatedButton(
              onPressed: (){
                 setState(() { _isShown = !_isShown;});
                 _resetPassword();
                 },
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
               child: const Text('Send password reset email.')),

          ],
        ),
        ):
        
        Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            
          ],
          ),
        ),
      ),
    );
  }
}