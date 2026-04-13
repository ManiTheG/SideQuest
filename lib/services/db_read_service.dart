import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sidequest/services/auth_service.dart';

class InterestsService {
  final AuthService _authService = AuthService();

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

class postsService{
  final AuthService _authService = AuthService();
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
    final user = _authService.currentUser;
    if(user != null){
      try{
        var query = await firestoreSideQuest
          .collection('users')
          .doc(user.uid)
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

}