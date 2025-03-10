import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Status otentikasi pengguna saat ini
  Stream<User?> get userStream => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Login dengan Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Memulai proses login Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      // Mendapatkan detail otentikasi dari permintaan
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Membuat credential untuk Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error saat login dengan Google: $e');
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
} 