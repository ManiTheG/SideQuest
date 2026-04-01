// ...existing code...
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

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

final List<String> _interesi = ["interes1", "interes2", "interes3", "interes4", "novo", "zanimljivo", "popularno", "tehnologija", "putovanja", "hrana", "fitness"];

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mc2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Mc2 Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<String> _selectedInterests = [];

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
      backgroundColor: Colors.teal,
      appBar: AppBar(title: const Text("Home")),
      body: SafeArea(
        child: Column(
          children: [
            // Interests row (wrap)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: SizedBox(
                height: 48,
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
            ),

            // Posts below
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.naslov, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(post.opis),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post.autor}', style: const TextStyle(fontStyle: FontStyle.italic)),
                                    Wrap(
                                      spacing: 6,
                                      children: post.interesi.map((i) => Chip(label: Text(i))).toList(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage.preset()));
      return;
}
          // switch selected tab for other indices (optional behavior)
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}