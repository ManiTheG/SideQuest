import 'package:sidequest/services/db_read_service.dart';
import 'package:flutter/material.dart';
import '../widget/bottom.dart';
import '../services/color_service.dart';


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
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final InterestsService _interestsService = InterestsService();

  List<String> _allInterests =[];
  final List<String> _selectedInterests = [];
  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newOpisController = TextEditingController();
  final List<String> _newPostInterests = [];

  @override
  void initState() {
    super.initState();
    _loadAllInterests();
  }

  void _selectToggle(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  Future<void> _loadAllInterests() async{
    final interests = await _interestsService.loadAllInterests();
   
    setState(() => _allInterests = interests);
  }


  List<Post> get _filteredPosts {
    if (_selectedInterests.isEmpty) return _posts;
    return _posts.where((p) => p.interesi.any((i) => _selectedInterests.contains(i))).toList();
  }

  void _openNewPostSheet() {
  _newPostInterests.clear(); // clear before opening
  _newTitleController.clear();
  _newOpisController.clear();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // allows it to grow with keyboard
    backgroundColor: AppColors.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder( 
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 
              MediaQuery.of(context).viewInsets.bottom + 16), // moves up with keyboard
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
                  children: _allInterests.map((interest) {
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
                    if (_newTitleController.text.isEmpty) return;
                    setState(() {
                      _posts.add(Post(
                        naslov: _newTitleController.text,
                        opis: _newOpisController.text,
                        autor: 'Me',
                        interesi: List.from(_newPostInterests),
                      ));
                    });
                    _newTitleController.clear();
                    _newOpisController.clear();
                    _newPostInterests.clear();
                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
       floatingActionButton: FloatingActionButton(
        onPressed: _openNewPostSheet,
        backgroundColor: AppColors.buttonColor,
        child: Icon(Icons.add, color: AppColors.textColor),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // tvoji interesi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.secondary,
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
                        children: _allInterests.map((interest) {
                          final isSelected = _selectedInterests.contains(interest);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                                      label: Text(
                                        interest,
                                        style: TextStyle(color: isSelected ? AppColors.textColor : AppColors.textColorOpis),
                                      ),
                                      selected: isSelected,
                                      onSelected: (_) => _selectToggle(interest),
                                      backgroundColor: AppColors.selectButtonColor,
                                      selectedColor: AppColors.buttonColor,
                                      //checkmarkColor: Colors.white,
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
                          style: TextStyle(color: AppColors.textColor),
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
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(16),
                              
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(post.naslov, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                                const SizedBox(height: 6),
                                Text(post.opis, style: TextStyle(color: AppColors.textColorOpis),),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post.autor}', style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.textColorAutor)),
                                    Wrap(
                                      spacing: 6,
                                      children: post.interesi.map((i) => Chip(
                                        label: Text(i, style: TextStyle(color: AppColors.textColor, fontSize: 12)),
                                        backgroundColor: AppColors.buttonColor,
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