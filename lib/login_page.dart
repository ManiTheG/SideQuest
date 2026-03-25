import 'package:flutter/material.dart';

class AppColors {
  static const primaryBackground = Color(0xFF101828);
  static const textColor = Colors.white;
  static const buttonColor = Colors.blue;
  static const inactiveButtonColor = Colors.grey;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true; // true: Sign In, false: Sign Up

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // placeholder za backend logiku.
  // zamijeniti stvarnim API/Firebase call-ovima.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Sim API delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // TODO: Backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.primaryBackground),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Toggle between Sign In and Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButton('Sign In', true),
                    const SizedBox(width: 8),
                    _buildToggleButton('Sign Up', false),
                  ],
                ),
                const SizedBox(height: 24),
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        _isLogin ? 'Welcome' : 'Create Account',
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: AppColors.textColor),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.textColor),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: AppColors.textColor),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: AppColors.textColor),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      if (!_isLogin) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          style: const TextStyle(color: AppColors.textColor),
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: AppColors.textColor),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      _isLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.buttonColor,
                            )
                          : ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                foregroundColor: AppColors.textColor,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(_isLogin ? 'Sign In' : 'Sign Up'),
                            ),
                      if (_isLogin) ...[
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // TODO: Forgot password logika.
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: AppColors.textColor),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isLogin) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isLogin = isLogin;
          _formKey.currentState?.reset();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: _isLogin == isLogin ? AppColors.buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.buttonColor),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _isLogin == isLogin ? AppColors.textColor : AppColors.buttonColor,
          ),
        ),
      ),
    );
  }
}