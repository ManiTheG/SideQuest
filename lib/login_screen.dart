import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  Future <void> _Login() async{
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

  Future <void> _ResetPassword() async{
    if(_emailController.text.isEmpty){
      setState(() => _errorMessage = 'Please enter your email to reset password.');
      return;
    }
    await _authService.resetPassword(_emailController.text);
    setState(()=> _errorMessage = 'Password reset email sent. Please check your inbox.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),  
              //keyboardType: TextInputType.visiblePassword,   
              obscureText: true,       
            ),
            if(_errorMessage !=null)...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
              onPressed: _Login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: _ResetPassword, 
              child: const Text('Forgot Password?')),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("Don't have an account? Signup and join us!"),
            ),
          ],
        ),
      ),
    );
  }
}