import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';

class AuthService {
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  fb_auth.User? get currentUser => _firebaseAuth.currentUser;
  Stream<fb_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();
  Future<fb_auth.UserCredential?> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<fb_auth.UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      await apiService.syncUser(name: name, email: email, phone: phone);

      return credential;
    } catch (e) {
      rethrow;
    }
  }


  Future<fb_auth.UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final fb_auth.AuthCredential credential =
          fb_auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      await apiService.syncUser(
        name: userCredential.user?.displayName,
        email: userCredential.user?.email,
      );

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      return await apiService.getUserProfile();
    } catch (e) {
      return null;
    }
  }

  String? _verificationId;
  int? _resendToken; // ignore: unused_field

  Future<void> sendVerificationOTP(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (fb_auth.PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (fb_auth.FirebaseAuthException e) {
        throw Exception(e.message ?? 'Phone verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<fb_auth.UserCredential> verifyPhoneOTP(
    String phoneNumber,
    String otp,
  ) async {
    if (_verificationId == null) {
      throw Exception('Please request OTP first');
    }

    final credential = fb_auth.PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    await apiService.syncUser(
      name: userCredential.user?.displayName,
      email: userCredential.user?.email,
      phone: phoneNumber,
    );

    return userCredential;
  }
}
