import 'package:sidequest/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/db_read_service.dart';
import 'package:flutter/material.dart';
import '../widget/bottom.dart';
import '../services/color_service.dart';

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
        userPosts = const [
          {
            'naslov': 'Prvo rješenje zagonetke',
            'opis': 'Podijelila sam rješenje moje omiljene zagonetke.',
            'autor': 'Slađana B.',
            'interesi': ['Puzzles', 'Tehnologija'],
          },
          {
            'naslov': 'D&D kampanja - savjeti',
            'opis': 'Kako voditi zanimljivu kampanju za početnike.',
            'autor': 'Slađana B.',
            'interesi': ['D&D'],
          },
          {
            'naslov': 'Putovanje u Sloveniju',
            'opis': 'Mali vodič i preporuke za putovanje.',
            'autor': 'Slađana B.',
            'interesi': ['Putovanja'],
          },
          {
            'naslov': 'Arhery basics',
            'opis': 'Osnove streličarstva za početnike.',
            'autor': 'Slađana B.',
            'interesi': ['Archery', 'Fitness'],
          },
          {
            'naslov': 'Novi trik za zagonetke',
            'opis': 'Kratki vodič s nekoliko brzih trikova za rješavanje logičkih zagonetki.',
            'autor': 'Slađana B.',
            'interesi': ['Puzzles'],
          },
        ];

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2;
  final AuthService _authService = AuthService();
  final InterestsService _interestsService = InterestsService();
  bool _isLoading = false;
  String? _errorMessage;

  List<String> _userInterests = [];

  
  @override
  void initState() {
    super.initState();
    _loadUserInterests();
    print(_userInterests);
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
    final posts = widget.userPosts;
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        title: const Text('Profile', style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
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
              ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: AppColors.textColor,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                elevation: 0,
              ),
              child: const Text('Logout', style: TextStyle(fontSize: 14)),
            ),
              // glavni profil kartica
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 36,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: const TextStyle(fontSize: 18, color: AppColors.textColor, fontWeight: FontWeight.bold),
                              ),
                              if (widget.userBio != null && widget.userBio!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(widget.userBio!, style: const TextStyle(color: AppColors.textColorOpis)),
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
                            backgroundColor: AppColors.buttonColor,
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                            ),
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

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [// lista interesa
                    Row(
                      children: [
                        const Text('Your Interests', style: TextStyle(color: AppColors.textColorAutor, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Spacer(),
                        GestureDetector(
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.buttonColor,
                            child: Icon(Icons.add, size: 18, color: AppColors.textColor),
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
                            backgroundColor: AppColors.buttonColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          );
                        },
                      ),
                    ),
                        ],
                  ),
                ),

              const SizedBox(height: 16),

              // lista postova
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Row(
                        children: [
                          const Text('Your Posts', style: TextStyle(color: AppColors.textColorAutor, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Spacer(),
                          GestureDetector(
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.buttonColor,
                              child: Icon(Icons.add, size: 18, color: AppColors.textColor),
                            ),
                          ),
                        ],
                      ),              const SizedBox(height: 8),
                      if (posts.isEmpty)
                      // prikaz kada nema postova
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.profilePost,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.insert_drive_file, size: 48, color: AppColors.textColorAutor),
                              const SizedBox(height: 8),
                              const Text('No Posts yet', style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.bold,
                              )),
                              const SizedBox(height: 4),
                              const Text('Share something with the community', style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textColorOpis,
                              )),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create post')));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonColor,
                                  foregroundColor: AppColors.textColor,
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  elevation: 0,
                                ),
                                child: const Text('Create Your First Post'),
                              ),
                            ],
                          ),
                        )
                      else
                      // prikaz postova ako ih ima
                        Column(
                          children: posts.map((p) {
                            final naslov = p['naslov'] ?? '';
                            final opis = p['opis'] ?? '';
                            final autor = p['autor'] ?? '';
                            final interesi = (p['interesi'] as List<dynamic>? ?? []).cast<String>();
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.profilePost,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(naslov, style: const TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(opis, style: TextStyle(color: AppColors.textColor,)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Autor: $autor', style: const TextStyle(color: AppColors.textColorAutor, fontStyle: FontStyle.italic)),
                                      Wrap(
                                        spacing: 6,
                                        children: interesi.map((i) => Chip(
                                        label: Text(i, style: TextStyle(color: AppColors.textColor, fontSize: 12)),
                                        backgroundColor: AppColors.buttonColor,
                                        side: BorderSide.none,
                                        padding: EdgeInsets.zero,
                                      )).toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                         ],
                      ),
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