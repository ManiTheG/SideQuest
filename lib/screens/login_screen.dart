import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'reset_password_screen.dart';
import 'signup_screen.dart';
import '../services/auth_service.dart';
import '../services/color_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(
        () => _errorMessage = 'Please enter email and password to proceed.',
      );
      _emailController.clear();
      _passwordController.clear();
      return;
    }

    if (!EmailValidator.validate(_emailController.text)) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      _emailController.clear();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(_emailController.text, _passwordController.text);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryBackground,
              AppColors.secondaryBackground,
            ],
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

              Image.asset('assets/icons/SQ2.png', height: 128),
              const SizedBox(height: 8),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Login to continue',
                style: TextStyle(color: AppColors.textColorAutor, fontSize: 20),
              ),
              const SizedBox(height: 20),

              //email inpput field, input tip je eamil, prelazi na password
              TextField(
                controller: _emailController,
                inputFormatters: [LengthLimitingTextInputFormatter(254)],
                style: TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: AppColors.textColorAutor),
                  filled: true,
                  fillColor: AppColors.selectButtonColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email],
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              //password input field, zvjezdasti tekst, n enter pozivae login
              TextField(
                controller: _passwordController,
                inputFormatters: [LengthLimitingTextInputFormatter(128)],
                style: TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: AppColors.textColorAutor),
                  filled: true,
                  fillColor: AppColors.selectButtonColor,
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

              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _errorMessage != null
                    ? Container(
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(
                            alpha: 0.15,
                          ), // light red background
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.4),
                          ), // subtle red border
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ),

              //tekstualni gumb za mjejanje lozinke
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textColor,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen(),
                  ),
                ),
                child: const Text('Forgot your Password?'),
              ),

              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.textColor,
                      ),
                    )
                  //gumb za poziv login funkcije
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: AppColors.textColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.buttonShadow.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

              //tekstualni gumb za promjenu na singup screen
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textColor,
                  alignment: Alignment.center,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                ),
                child: const Text(
                  "Don't have an account? Sign up and join us!",
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
