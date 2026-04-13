import 'package:sidequest/services/db_read_service.dart';
import 'package:flutter/material.dart';
import '../widget/bottom.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final ScrollController _scrollController = ScrollController();
  
  final InterestsService _interestsService = InterestsService();
  final postsService _postsService = postsService();

  List<String> _userInterests =[];
  List<Map<String, dynamic>> _allPosts = [];

  final List<String> _selectedInterests = [];


  @override
  void initState() {
    super.initState();
    _loadUserInterests().then((_) =>  _loadFilteredPosts());
    print('================================================================' );


    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent - 200){
        if(_postsService.morePostsAvailable){
          _loadFilteredPosts();
        }
      }
    });
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