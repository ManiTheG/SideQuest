import 'package:sidequest/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/db_read_service.dart';
import 'package:flutter/material.dart';
import '../widget/bottom.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String? userBio;
  final List<String> userInterests;
  // List of maps with keys: 'naslov','opis','autor','interesi'
  final List<Map<String, dynamic>> userPosts;

  const ProfilePage({
    super.key,
    required this.userName,
    this.userBio,
    required this.userInterests,
    required this.userPosts,
  });

  // Preset constructor with sample data
  const ProfilePage.preset({super.key})
      : userName = 'Slađana B.',
        userBio = 'Puzzle Master',
        userInterests = const [],
        userPosts = const [];

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2;
  //final AuthService _authService = AuthService();
  final InterestsService _interestsService = InterestsService();
  final postsService _postsService = postsService();

  List<String> _userInterests = [];
  List<Map<String, dynamic>> _userPosts = [];


  
  @override
  void initState() {
    super.initState();
    _loadUserInterests();
    _loadUserPosts();
  }

    Future<void> _loadUserPosts() async{
    final posts = await _postsService.loadUserPosts();

    setState(() => _userPosts = posts);
  }

  Future<void> _loadUserInterests() async{
    final interests = await _interestsService.loadUserInterests();
   
    setState(() => _userInterests = interests);
  }

  Future<void> _logout() async {

    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );}
  }


  @override
  Widget build(BuildContext context) {
   // final posts = widget.userPosts;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings tapped')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(onPressed:_logout, 
              child: const Text('Logout')),
              // glavni profil kartica
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 36,
                         // backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              if (widget.userBio != null && widget.userBio!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(widget.userBio!, style: const TextStyle(color: Colors.white70)),
                                ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit profile')));
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(ProfilePage.preset().userPosts.length.toString(), 'Posts'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // lista interesa
               Row(
                children: [
                  const Text('Your Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Spacer(),
                  GestureDetector(
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.add, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _userInterests.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final interest = _userInterests[i];
                    return FilterChip(
                      label: Text(interest),
                      selected: false,
                      onSelected: (_) {},
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // lista postova
              Row(
                children: [
                  const Text('Your Posts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Spacer(),
                  GestureDetector(
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.add, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),              const SizedBox(height: 8),
              if (_userPosts.isEmpty)
              // prikaz kada nema postova
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.insert_drive_file, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text('No Posts yet', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create post')));
                          },
                          child: Text('Create Your First Post'),
                        ),
                      ],
                    ),
                  ),
                )
              else
              // prikaz postova ako ih ima
                Column(
                  children: _userPosts.map((p) {
                    final naslov = p['title'] ?? '';
                    final opis = p['description'] ?? '';
                    final autor = p['authorId'] ?? '';
                    final interesi = (p['interests'] as List<dynamic>? ?? []).cast<String>();
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
                          Text(naslov, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(opis),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Autor: $autor', style: const TextStyle(fontStyle: FontStyle.italic)),
                              Wrap(
                                spacing: 6,
                                children: interesi.map((i) => Chip(label: Text(i))).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      // bottom navigation bar
      bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}