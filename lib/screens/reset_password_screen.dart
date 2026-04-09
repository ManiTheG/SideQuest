import 'package:flutter/material.dart';
import '../services/auth_service.dart';
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

            SafeArea(
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

            Spacer(),

            Text('Enter email to send password reset', 
            style: TextStyle(
              color: Colors.white60, 
              fontSize: 18,)),
              Padding(padding: const EdgeInsets.only(bottom: 20)),
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
            ),

            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _errorMessage != null ? 
              Container(
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

            const SizedBox(height: 16),

            _isLoading? const Center(child: CircularProgressIndicator())
            //gumb za poziv login funkcije
            : ElevatedButton(
              onPressed: (){
                 _resetPassword();
                 },
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor: Color.fromARGB(255, 16, 103, 234),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),
                  elevation: 4,
                  shadowColor: Color(0xFF6C63FF).withValues(alpha: 0.4)
                ),
               child: const Text('Reset password', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
               ),
            Spacer(),
            Spacer()
          ],
        ),
        ):
        
        Padding(padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            SafeArea(
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

            Spacer(),

            Text('Password reset email sent. Please check your inbox.', 
            style: TextStyle(
              color: Colors.white60, 
              fontSize: 18,)),
              const SizedBox(height: 20),
             ElevatedButton(
              onPressed: (){
                 Navigator.pop(context);
                 },
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor: Color.fromARGB(255, 16, 103, 234),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),
                  elevation: 4,
                  shadowColor: Color(0xFF6C63FF).withValues(alpha: 0.4)
                ),
               child: const Text('Back to login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
               ),

            
          ],
        ),
      ),
      ), 
    );
  }
}