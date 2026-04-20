import 'package:sidequest/screens/login_screen.dart';
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
        userPosts = const [];

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2;
  
  final AuthService _authService = AuthService();
  final InterestsService _interestsService = InterestsService();
  final PostsService _postsService = PostsService();
  final UserInfo _userInfo = UserInfo();

  List<String> _userInterests = [];
  List<Map<String, dynamic>> _userPosts = [];
  String _username = '';
  final String _userBio = '';

  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newOpisController = TextEditingController();
  final List<String> _newPostInterests = [];

  
 @override
  void initState() {
    super.initState();
    _loadUserInterests();
    _loadUserPosts();
    _getUsername();
  }

  Future<void> _getUsername() async{
    final username = await _userInfo.getUsername();

    setState(()=> _username = username);
  }

  Future<void> _loadUserPosts() async{
    final posts = await _postsService.loadUserPosts();

    setState(() => _userPosts = posts);
  }

  Future<void> _loadUserInterests() async{
    final interests = await _interestsService.loadUserInterests();
   
    setState(() => _userInterests = interests);
  }


  void _openNewPostSheet() {
  _newPostInterests.clear();
  _newTitleController.clear();
  _newOpisController.clear();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder( 
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 
              MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('New Post', style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 16),

                // title field
                TextField(
                  controller: _newTitleController,
                  style: TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: AppColors.textColorOpis),
                    filled: true,
                    fillColor: AppColors.selectButtonColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // post body field
                TextField(
                  controller: _newOpisController,
                  style: TextStyle(color: AppColors.textColor),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Write your post...',
                    labelStyle: TextStyle(color: AppColors.textColorOpis),
                    filled: true,
                    fillColor: AppColors.selectButtonColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // tags
                Text('Tags', style: TextStyle(color: AppColors.textColorOpis)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _userInterests.map((interest) {
                    final isSelected = _newPostInterests.contains(interest);
                    return FilterChip(
                      label: Text(interest, style: TextStyle(
                        color: isSelected ? AppColors.textColor : AppColors.textColorOpis,
                      )),
                      selected: isSelected,
                      onSelected: (_) {
                        setSheetState(() { 
                          if (isSelected) {
                            _newPostInterests.remove(interest);
                          } else {
                            _newPostInterests.add(interest);
                          }
                        });
                      },
                      backgroundColor: AppColors.selectButtonColor,
                      selectedColor: AppColors.buttonColor,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // submit button
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    foregroundColor: AppColors.textColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Post'),
                ),
              ],
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    setState(() {
      _newTitleController.clear();
      _newOpisController.clear();
      _newPostInterests.clear();
    });
    });
}

  Future<void> _logout() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text(
        'Logout',
        style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Are you sure you want to logout?',
        style: TextStyle(color: AppColors.textColorOpis),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonColor,
            foregroundColor: AppColors.textColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );}
  }
}


  @override
  Widget build(BuildContext context) {
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
                                _username,
                                style: const TextStyle(fontSize: 18, color: AppColors.textColor, fontWeight: FontWeight.bold),
                              ),
                              if (_userBio != null && _userBio.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(_userBio, style: const TextStyle(color: AppColors.textColorOpis)),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit profile')));
                              },
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                foregroundColor: AppColors.textColor,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Logout', style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
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
                          const Text('Your interests', style: TextStyle(color: AppColors.textColorAutor, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(8),
                              shape: const CircleBorder(),
                              elevation: 0,
                            ),
                            child: const Icon(Icons.add, size: 18, color: AppColors.textColor),
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
                            label: Text(interest, style: TextStyle(color: AppColors.textColor),),
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
                          const Text('Your Posts', style: TextStyle(color: AppColors.textColorAutor, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _openNewPostSheet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(8),
                              shape: const CircleBorder(),
                              elevation: 0,
                            ),
                            child: const Icon(Icons.add, size: 18, color: AppColors.textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_userPosts.isEmpty)
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
                                onPressed: _openNewPostSheet,
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
                          children: _userPosts.map((p) {
                            final title = p['title'] ?? '';
                            final description = p['description'] ?? '';
                            final authorId = p['authorId'] ?? '';
                            final interests = (p['interests'] as List<dynamic>? ?? []).cast<String>();
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
                                  Text(title, style: const TextStyle(color: AppColors.textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(description, style: TextStyle(color: AppColors.textColor,)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Autor: $authorId', style: const TextStyle(color: AppColors.textColorAutor, fontStyle: FontStyle.italic)),
                                      Wrap(
                                        spacing: 6,
                                        children: interests.map((i) => Chip(
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