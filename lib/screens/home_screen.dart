import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;


  Future<void> _logout() async {
  try{
      await _authService.logout();
    }
    catch(e){
      setState(() => _errorMessage = e.toString());
    }finally{
      setState(() => _isLoading = false);
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              TextButton(
                onPressed: _logout,
                child: const Text('Logout'),
                ),
          ],
      ),
      ),
    );
  }

}