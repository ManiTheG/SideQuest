import 'package:sidequest/services/db_read_service.dart';
import 'package:flutter/material.dart';
import '../widget/bottom.dart';
import '../services/color_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final ScrollController _scrollController = ScrollController();
  
  final InterestsService _interestsService = InterestsService();
  final PostsService _postsService = PostsService();

  List<String> _userInterests =[];
  List<Map<String, dynamic>> _allPosts = [];

  final List<String> _selectedInterests = [];
  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newOpisController = TextEditingController();
  final List<String> _newPostInterests = [];

  @override
  void initState() {
    super.initState();
    _loadUserInterests().then((_) =>  _loadFilteredPosts());
    
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent - 200){
        if(_postsService.morePostsAvailable){
          _loadFilteredPosts();
        }
      }
    });
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _loadUserInterests() async{
    final interests = await _interestsService.loadUserInterests();
   
    if(mounted){setState(() => _userInterests = interests);}
  }

  Future<void> _loadFilteredPosts() async{
    final posts = await _postsService.loadPosts(_userInterests);

    if(mounted){setState(() => _allPosts = posts);}
  }


  List<Map<String, dynamic>> get _filteredPosts {
    if (_selectedInterests.isEmpty) return _allPosts;
    return _allPosts.where((p) {
      final interests = List<String>.from(p['interests']??[]);
      return interests.any((i) => _selectedInterests.contains(i));
    }).toList();
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
                    if (_newTitleController.text.isEmpty) return;
                    setState(() {
                      //TODO: post logika
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
                  child: Text(
                    'Post',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                    ),
                ),
                const SizedBox(height: 48),
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
      backgroundColor: Color.fromARGB(255, 16, 24, 40),
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
                        children: _userInterests.map((interest) {
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
                          'Currently no available post for chosen interests',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                      controller: _scrollController,
                        itemCount: _filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = _filteredPosts[index];

                          if (index == _allPosts.length) {
                            return _postsService.morePostsAvailable
                              ? const Center(child: CircularProgressIndicator())
                              : const Center(child: Text('No more posts', style: TextStyle(color: Colors.white)));
                          }

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
                                
                                Text(post['title']??'', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text(post['description']??'', style: TextStyle(color: Colors.white70),),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post['authorId']??''}', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white60)),
                                    Wrap(
                                      spacing: 6,
                                      children: (post['interests'] as List<dynamic>? ?? []).cast<String>().map((i) => Chip(
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