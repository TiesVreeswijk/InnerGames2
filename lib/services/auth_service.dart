import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> ensureSignedIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) return currentUser;

    final credential = await _auth.signInAnonymously();
    final user = credential.user;

    if (user == null) {
      throw Exception('Anonymous sign-in failed.');
    }

    return user;
  }

  User? get currentUser => _auth.currentUser;
}