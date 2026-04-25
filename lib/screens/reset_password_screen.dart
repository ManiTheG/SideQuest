import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/color_service.dart';
import 'package:email_validator/email_validator.dart';

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
    
    if (!EmailValidator.validate(_emailController.text)) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      _emailController.clear();
      return;
    }


     setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try{
      await _authService.resetPassword(_emailController.text);
      //setState(()=> _errorMessage = 'Password reset email sent. Please check your inbox.');
      //setState(() { _isShown = !_isShown;});
    } catch(e){
      setState(() => _errorMessage = e.toString());
    }finally{
      setState((){ 
        _isLoading = false;
        _isShown = !_isShown;
        });
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBackground, AppColors.secondaryBackground],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // centered content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _isShown
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Enter email to send password reset',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textColorAutor, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
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
                        ),
                        AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _errorMessage != null
                              ? Container(
                                  margin: EdgeInsets.only(top: 16),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
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
                        const SizedBox(height: 16),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _resetPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonColor,
                                  foregroundColor: AppColors.textColor,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 4,
                                  shadowColor: Color(0xFF6C63FF).withValues(alpha: 0.4),
                                ),
                                child: const Text(
                                  'Reset password',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Password reset email sent. Please check your inbox.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textColorAutor, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            foregroundColor: AppColors.textColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 4,
                            shadowColor: AppColors.buttonShadow.withValues(alpha: 0.4),
                          ),
                          child: const Text(
                            'Back to login',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.textColor),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}