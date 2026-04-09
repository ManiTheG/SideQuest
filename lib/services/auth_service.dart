import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final firestoreSideQuest = FirebaseFirestore.instanceFor(
  app: Firebase.app(),
  databaseId: 'sidequest-db',
);

class AuthService {

  // instanciranje FirebaseAuth-a koji će se bbrinuti za autentifikaciju
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  // getter za Stream podataka (login user/logout null) u kojem auth sluša promjene
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // getter za trenutnog korisnika (ako je prijavljen) ili null
  User? get currentUser => _auth.currentUser;

  // fukcija za singup korisnika. pokušava kreirat user-a, ako uspije vrača UserCredetials ako ne, baca error
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }


  //funkcija za login korisnika. Pokušava prijavit korisnika, ako uspije vrača UserCredetials ako ne, baca error
  Future<UserCredential> login(String email, String password) async {
  
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
      
    }
  }

  //fnkcija za logout/sign out
  Future<void> logout() async {
    await _auth.signOut();
  }

  //resetiranje lozinke. Pokušava poslati email za resetiranje lozinke, ako ne uspije baca error
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }

  // Firebase error se prevodi/mapira u razumnije poruke za korisnika
  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}