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

class userInfo{

}