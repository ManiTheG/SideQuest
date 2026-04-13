import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_options.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import '../widget/bottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String naslov;
  final String opis;
  final String autor;
  final List<String> interesi;

  Post({
    required this.naslov,
    required this.opis,
    required this.autor,
    required this.interesi,
  });
}

final List<Post> _posts = [
  Post(
    naslov: 'Moj prvi post',
    opis: 'Opis posta',
    autor: 'Ivan',
    interesi: ['interes1', 'interes2'],
  ),
  Post(
    naslov: 'Drugi post',
    opis: 'Neki opis',
    autor: 'Ana',
    interesi: ['interes2', 'interes3'],
  ),
  Post(
    naslov: 'Treći post',
    opis: 'Još jedan opis',
    autor: 'Marko',
    interesi: ['interes4'],
  ),
  Post(
    naslov: 'Putovanja i avanture',
    opis: 'Koristan vodič za budžetno putovanje po Europi.',
    autor: 'Luka',
    interesi: ['interes1', 'interes3'],
  ),
  Post(
    naslov: 'Recept dana',
    opis: 'Brzi recept za ukusnu vegansku tjesteninu.',
    autor: 'Maja',
    interesi: ['interes2'],
  ),
  Post(
    naslov: 'Tehnologija 2026',
    opis: 'Pregled najzanimljivijih trendova u mobilnom razvoju.',
    autor: 'Petar',
    interesi: ['interes3', 'interes4'],
  ),
  Post(
    naslov: 'Fit & zdravlje',
    opis: 'Jednostavan plan treninga za početnike kod kuće.',
    autor: 'Sara',
    interesi: ['interes1', 'interes4'],
  ),
  Post(
    naslov: 'Knjiga koju vrijedi pročitati',
    opis: 'Kratka recenzija i citati iz najbolje prodavane knjige.',
    autor: 'Ivona',
    interesi: ['interes2', 'interes3'],
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _selectedInterests = [];

  List<String> _interesi = [  
    'interes1',
    'interes2',
    'interes3',
    'interes4',
  ];

  void _selectToggle(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }


  List<Post> get _filteredPosts {
    if (_selectedInterests.isEmpty) return _posts;
    return _posts.where((p) => p.interesi.any((i) => _selectedInterests.contains(i))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 24, 40),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // tvoji interesi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 25, 36, 54),
                borderRadius: BorderRadius.only(
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _interesi.map((interest) {
                          final isSelected = _selectedInterests.contains(interest);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                                      label: Text(
                                        interest,
                                        style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                                      ),
                                      selected: isSelected,
                                      onSelected: (_) => _selectToggle(interest),
                                      backgroundColor: const Color.fromARGB(255, 55, 73, 87),
                                      selectedColor: const Color.fromARGB(255, 16, 103, 234),
                                      checkmarkColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      showCheckmark: false,
                                    ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TextButton(onPressed: _logout, child: const Text('Logout')),

            // Postovi
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _filteredPosts.isEmpty
                    ? const Center(
                        child: Text(
                          'Nema postova za odabrane interese',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = _filteredPosts[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 25, 36, 54),
                              borderRadius: BorderRadius.circular(16),
                              
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(post.naslov, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text(post.opis, style: TextStyle(color: Colors.white70),),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post.autor}', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white60)),
                                    Wrap(
                                      spacing: 6,
                                      children: post.interesi.map((i) => Chip(
                                        label: Text(i, style: TextStyle(color: Colors.white, fontSize: 12)),
                                        backgroundColor: Color.fromARGB(255, 16, 103, 234),
                                        padding: EdgeInsets.zero,
                                      )).toList(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      //bottom navigation bar
      bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 0),
    );
  }
}