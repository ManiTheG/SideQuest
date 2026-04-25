import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sidequest/services/auth_service.dart';

final AuthService _authService = AuthService();

class InterestsService {
  Future<List<String>> loadAllInterests() async {
    try{
      final doc = await firestoreSideQuest
      .collection('interests')
      .doc('iU9mh7KTkFWkKarbdCXe')
      .get();

      if(doc.exists && doc.data() != null && doc.get('name') != null) {
        final data = doc['name'];
        if(data is List){
          return List<String>.from(data.map((e)=>e.toString()));
        }
      }
      return [];
    }catch (e) {
      throw Exception('Failed to load interests: $e');
    }
  }

  Future<List<String>> loadUserInterests() async {
    final user = _authService.currentUser;
    if(user != null){
      try{ 
        final doc = await firestoreSideQuest
        .collection('users')
        .doc(user.uid)
        .get();
        if(doc.exists && doc.data() != null && doc.get('interests') != null) {
          final data = doc['interests'];
          if(data is List){
            return List<String>.from(data.map((e)=> e.toString()));
          }      
        } 
      }catch (e) {
        throw Exception('Failed to load user interests: $e');
      }
    }
    return [];
  }

}

class PostsService{
  bool morePostsAvailable = true;
  QueryDocumentSnapshot? _lastAllDocument;

  Future<List<Map<String, dynamic>>> loadPosts(List<String>? interestFilter) async {
    try {
      var query = await firestoreSideQuest
          .collection('posts')
          .orderBy('created', descending: true)
          .limit(20);
      
      if(interestFilter != null && interestFilter.isNotEmpty){
        query = query.where('interests', arrayContainsAny: interestFilter);
      }

      if(_lastAllDocument != null){
        query = query.startAfterDocument(_lastAllDocument!);
      }

      final querySnapshot = await query.get();

      if(querySnapshot.docs.length < 20){
        morePostsAvailable = false;
      }
      if(querySnapshot.docs.isNotEmpty){
        _lastAllDocument = querySnapshot.docs.last;
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'authorId': data['authorId'] ?? '',
          'interests': List<String>.from(data['interests'] ?? []),
          'created': data['created'],
        };
      }).toList();

    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadUserPosts() async{
    final _user = _authService.currentUser;
    if(_user != null){
      try{
        var query = await firestoreSideQuest
          .collection('users')
          .doc(_user.uid)
          .collection('posts')
          .orderBy('created', descending: true);

        final querySnapshot = await query.get();

        return querySnapshot.docs.map((doc) {

        final data = doc.data();

        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'authorId': data['authorId'] ?? '',
          'interests': List<String>.from(data['interests'] ?? []),
          'created': data['created'],
        };
      }).toList();

      }catch (e) {
        throw Exception('Failed to load user posts: $e');
      }
    }
    return [];
  }

  Future<void> newPost(String _newTitleController, String _newOpisController, List<String> _newPostInterests, ) async{
    try{
    final refrence = await firestoreSideQuest.collection('posts').add(
      { 'authorId': await _userInfo.getUsername(),
        'title': _newTitleController.trim(),
        'description': _newOpisController.trim(),
        'interests': _newPostInterests,
        'created': FieldValue.serverTimestamp(),
      },
    ).timeout( Duration(seconds: 10 ), onTimeout: ()=> throw Exception('Request timed out. please try again'));
      
    final user = _authService.currentUser;
    await firestoreSideQuest.collection('users').doc(user!.uid).collection('posts').add(
      {
        'postId': refrence.id,
        'authorId': await _userInfo.getUsername(),
        'title': _newTitleController.trim(),
        'description': _newOpisController.trim(),
        'interests': _newPostInterests,
        'created': FieldValue.serverTimestamp(),
      },
      ).timeout( Duration(seconds: 10 ), onTimeout: ()=> throw Exception('Request timed out. please try again'));
    }catch(e){
      throw Exception('Failed to create a post: $e');
    }

  }

  void refresh() {
    _lastAllDocument = null;
    morePostsAvailable = true;
  }

}

class UserInfo{
  final _userInfo = _authService.currentUser;
  String _username = '';
  String _bio = ' ';

  Future<String> getData() async{
     try{
      var snap = await firestoreSideQuest
      .collection('users')
      .doc(_userInfo!.uid)
      .get();

      if(snap.exists){
        Map<String, dynamic>? data =snap.data();
        var _usernameRead = data?['username'];
        var _bioRead = data?['bio'];
        _username = _usernameRead.toString();
        _bio = _bioRead.toString();
      }
      return '';
    }catch (e){
      throw Exception('Failed to load user data $e');
    }
  }

  Future<String> getUsername() async{
    try{
      await getData();
      return _username;
    }catch (e){
      throw Exception('Failed to load username $e');
    }
  }

  Future<String> getbio() async{
    try{
      await getData();
      return _bio;
    }catch (e){
      throw Exception('Failed to load bio $e');
    }
  }

}

final UserInfo _userInfo = UserInfo();