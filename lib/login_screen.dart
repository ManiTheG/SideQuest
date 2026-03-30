import 'package:flutter/material.dart';
import 'package:sidequest/signup_screen.dart';
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

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            //Icon(Icons.lock_rounded, size: 64, color: Colors.white),
            //Image.asset('assets/img/SQ.png', height: 64),
            const SizedBox(height: 8),
            Text('Welcome Back', style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
            const SizedBox(height: 8),
            Text('Login to continue', style: TextStyle(color: Colors.white60, fontSize: 20)),
            const SizedBox(height: 20),

            //email inpput field, input tip je eamil, prelazi na password
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            //password input field, zvjezdasti tekst, n enter pozivae login
            TextField(
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
              //keyboardType: TextInputType.visiblePassword,   
              obscureText: true,   
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _login(),   
            ),

            //Postojanje greske ispod password polja
            /*if(_errorMessage !=null)...[
              const SizedBox(height: 16),
              Padding(padding: const EdgeInsets.only(left: 24)),
              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red),),
            ],*/

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

             //tekstualni gumb za mjejanje lozinke
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                alignment: Alignment.centerLeft,
                ),
              onPressed: _resetPassword, 
              child: const Text('Forgot Password?')),

            _isLoading? const Center(child: CircularProgressIndicator())
            //gumb za poziv login funkcije
            : ElevatedButton(
              onPressed: _login,
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
              child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            //tekstualni gumb za promjenu na singup screen
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                alignment: Alignment.center,
                ),
              onPressed:  ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()),
              ), 
              child: const Text("Don't have an account? Sign up and join us!"),
            ),
            const SizedBox(height: 100,)
          ],
        ),
      ),
      ),
    );
  }
}