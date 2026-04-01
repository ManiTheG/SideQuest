import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2; // profile tab

  void _onTap(int index) {
    if (index == 0) {
      // vraćamo se na Home (pretpostavka: otvoreno preko Navigator.push)
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        // ako nema povratka, prikazemo jednostavnu poruku
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Home nije dostupan za povratak')),
        );
      }
      return;
    }

    if (index == 1) {
      // Search nije implementiran — prikaz kratke poruke
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Search nije implementiran')),
      );
      setState(() => _currentIndex = index);
      return;
    }

    // index == 2 -> ostajemo na profilu
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
            ),
            SizedBox(height: 16),
            Text(
              "John Doe",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Flutter Developer",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
// ...existing code...