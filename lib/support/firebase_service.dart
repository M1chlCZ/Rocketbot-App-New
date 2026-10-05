
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static Future<void>? _googleSignInInitialization;

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= _googleSignIn.initialize();
  }

  Future<String?> signInwithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final GoogleSignInAccount googleSignInAccount =
      await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleSignInAuthentication =
      googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );
      // print("///" + credential.token.toString());
      // print("///" + credential.toString());
      await _auth.signInWithCredential(credential);
      return googleSignInAuthentication.idToken;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("/////${e.message}");
      }
      // throw e;
    }
    return null;
  }

  Future<void> signOutFromGoogle() async{
    await _ensureGoogleSignInInitialized();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
