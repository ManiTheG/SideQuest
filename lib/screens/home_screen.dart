import '../services/auth_service.dart';
import '../services/db_read_service.dart';
import '../widget/bottom.dart';
import '../services/color_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _errorMessage;
  bool _isLoading = false;

  final ScrollController _scrollController = ScrollController();
  final InterestsService _interestsService = InterestsService();
  final PostsService _postsService = PostsService();

  List<String> _userInterests = [];
  List<Map<String, dynamic>> _allPosts = [];

  final List<String> _selectedInterests = [];
  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newOpisController = TextEditingController();
  final List<String> _newPostInterests = [];

  @override
  void initState() {
    super.initState();
    _loadUserInterests().then((_) => _loadFilteredPosts());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (_postsService.morePostsAvailable) {
          _loadFilteredPosts();
        }
      }
    });
  }

  @override
  void dispose() {
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

  Future<void> _newPost() async {
    if (_newTitleController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a title');
      return;
    } else if (_newOpisController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a description');
      return;
    } else if (_newPostInterests.isEmpty) {
      setState(
        () => _errorMessage = 'Please select interests related to your post',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _postsService.newPost(
        _newTitleController.text,
        _newOpisController.text,
        _newPostInterests,
      );
    } catch (e) {
      setState(() => _errorMessage = 'Failed to create a post');
    } finally {
      setState(() => _isLoading = false);
    }

    if (mounted) {
      _newTitleController.clear();
      _newOpisController.clear();
      _newPostInterests.clear();
      Navigator.pop(context);
    }
  }

  Future<void> _loadUserInterests() async {
    final interests = await _interestsService.loadUserInterests();

    if (mounted) {
      setState(() => _userInterests = interests);
    }
  }

  Future<void> _loadFilteredPosts() async {
    final posts = await _postsService.loadPosts(_userInterests);
    if (mounted) {
      setState(() => _allPosts.addAll(posts));
    }
  }

  List<Map<String, dynamic>> get _filteredPosts {
    if (_selectedInterests.isEmpty) return _allPosts;
    return _allPosts.where((p) {
      final interests = List<String>.from(p['interests'] ?? []);
      return interests.any((i) => _selectedInterests.contains(i));
    }).toList();
  }

  void _openNewPostSheet() {
    _newPostInterests.clear(); // clear before opening
    _newTitleController.clear();
    _newOpisController.clear();
    _errorMessage = null;

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
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New Post',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  Text(
                    'Tags',
                    style: TextStyle(color: AppColors.textColorOpis),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _userInterests.map((interest) {
                      final isSelected = _newPostInterests.contains(interest);
                      return FilterChip(
                        label: Text(
                          interest,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.textColor
                                : AppColors.textColorOpis,
                          ),
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),

                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _errorMessage != null
                        ? Container(
                            margin: EdgeInsets.only(top: 16),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(
                                alpha: 0.15,
                              ), // light red background
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.4),
                              ), // subtle red border
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ),

                  const SizedBox(height: 16),

                  // submit button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _newPost,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            foregroundColor: AppColors.textColor,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
        top: true,
        child: Column(
          children: [
            // tvoji interesi
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
                16,
                16,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground,
                borderRadius: BorderRadius.only(),
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
                          final isSelected = _selectedInterests.contains(
                            interest,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(
                                interest,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.textColor
                                      : AppColors.textColorOpis,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) => _selectToggle(interest),
                              backgroundColor: AppColors.selectButtonColor,
                              selectedColor: AppColors.buttonColor,
                              checkmarkColor: AppColors.textColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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

            // Postovi
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _filteredPosts.isEmpty
                    ? const Center(
                        child: Text(
                          'Currently no available post for chosen interests',
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.textColor,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        displacement: 0,
                        onRefresh: () async {
                          setState(() => _allPosts.clear());
                          _postsService.refresh();
                          await _loadFilteredPosts();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredPosts.length,
                          itemBuilder: (context, index) {
                            final post = _filteredPosts[index];

                            if (index == _allPosts.length) {
                              return _postsService.morePostsAvailable
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Center(
                                      child: Text(
                                        'No more posts',
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                        ),
                                      ),
                                    );
                            }

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
                                  Text(
                                    post['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    post['description'] ?? '',
                                    style: TextStyle(
                                      color: AppColors.textColorOpis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Author: ${post['authorId'] ?? ''}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.textColorAutor,
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 6,
                                        children:
                                            (post['interests']
                                                        as List<dynamic>? ??
                                                    [])
                                                .cast<String>()
                                                .map(
                                                  (i) => Chip(
                                                    label: Text(
                                                      i,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.textColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        AppColors.buttonColor,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
