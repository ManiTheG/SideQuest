import 'package:flutter/material.dart';
import 'package:sidequest/signup_screen.dart';
import '../services/auth_service.dart';

class AppColors {
  static const primaryBackground = Color(0xFF101828);
  static const textColor = Colors.white;
  static const buttonColor = Colors.blue;
  static const inactiveButtonColor = Colors.grey;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future <void> _login() async{

    if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
      setState(() => _errorMessage = 'Please enter email and password to proceed.');
      _emailController.clear();
      _passwordController.clear();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try{
      await _authService.login(_emailController.text, _passwordController.text);
    }
    catch(e){
      setState(() => _errorMessage = e.toString());
    }finally{
      setState(() => _isLoading = false);
    }

  }

  //mjenjat će se još amo plaseholder fiunkcaja mjenjanje
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
      setState(() => _errorMessage =e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            //email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            //password
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),  
              //keyboardType: TextInputType.visiblePassword,   
              obscureText: true,   
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(),   
            ),

            //Postojanje greske ispod password polja
            if(_errorMessage !=null)...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            _isLoading
            ? const Center(child: CircularProgressIndicator())

            //gumb za poziv login funkcije
            : ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            
            //tekstualni gumb za mjejanje lozinke
            TextButton(
              onPressed: _resetPassword, 
              child: const Text('Forgot Password?')),

            //tekstualni gumb za promjenu na singup screen
            TextButton(
              onPressed:  ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()),
              ), 
              child: const Text("Don't have an account? Sign up and join us!"),
            ),
          ],
        ),
      ),
    );
  }
}