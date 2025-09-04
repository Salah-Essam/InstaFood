import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_food/presentation/features/auth/data/model/user_model.dart';
import 'package:insta_food/core/network/Firebase/firebase_firestore_service.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestoreService _firestoreService;

  AuthRepository(
    this._firebaseAuth,
    this._firestoreService,
  );

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
    required String dateOfBirth,
    required String phone,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final profile = UserModel(
      id: userCredential.user!.uid,
      fullName: fullName,
      email: email,
      dateOfBirth: dateOfBirth,
      phone: phone,
    );

    await _firestoreService.addUser(profile);

  return profile;
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      // Sign in with FirebaseAuth first (source of truth)
      final cred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final uid = cred.user?.uid;
      if (uid == null) return null;
      // Fetch profile from Firestore
      var profile = await _firestoreService.getUserById(uid) ?? await _firestoreService.getUserByEmail(email);
      if (profile == null) {
        final minimal = UserModel(
          id: uid,
          fullName: _firebaseAuth.currentUser?.displayName ?? '',
          email: _firebaseAuth.currentUser?.email ?? email,
          dateOfBirth: '',
          phone: _firebaseAuth.currentUser?.phoneNumber ?? '',
        );
        await _firestoreService.addUser(minimal);
        profile = minimal;
      }
      return profile;
    } catch (_) {
    }
    return null;
  }

  // Trigger Firebase to send a password reset email to the user.
  Future<bool> changePasswordByEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Check if user exists by email
  Future<bool> userExistsByEmail(String email) async {
    try {
      final profile = await _firestoreService.getUserByEmail(email);
      return profile != null;
    } catch (_) { return false; }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  UserModel? getCurrentUser() {
    final u = _firebaseAuth.currentUser;
    if (u == null) return null;
    return UserModel(
      id: u.uid,
      fullName: u.displayName ?? '',
      email: u.email ?? '',
      phone: u.phoneNumber ?? '',
      dateOfBirth: '',
    );
  }
}
