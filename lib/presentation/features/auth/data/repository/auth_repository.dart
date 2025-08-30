import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/presentation/features/auth/data/model/user_model.dart';
import 'package:insta_food/core/network/Firebase/firebase_firestore_service.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestoreService _firestoreService;
  final Box _userBox;

  AuthRepository(
    this._firebaseAuth,
    this._firestoreService,
    this._userBox,
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
      password: password,
      dateOfBirth: dateOfBirth,
      phone: phone,
    );

    // Store ONLY public profile in Firestore (no password)
    await _firestoreService.addUser(profile);

    // Cache locally including password (legacy requirement)
    await _userBox.put('currentUser', profile.toMap());

    return profile;
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      // Sign in with FirebaseAuth first (source of truth)
      final cred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final uid = cred.user?.uid;
      if (uid == null) return null;
      // Fetch profile from Firestore
      final profile = await _firestoreService.getUserById(uid) ?? await _firestoreService.getUserByEmail(email);
      if (profile == null) return null;
      // Merge local password (we only have the input password)
      final merged = UserModel(
        id: profile.id,
        fullName: profile.fullName,
        email: profile.email,
        password: password,
        dateOfBirth: profile.dateOfBirth,
        phone: profile.phone,
      );
      await _userBox.put('currentUser', merged.toMap());
      return merged;
    } catch (_) {
      // If no internet → check Hive
      final cachedUser = _userBox.get("currentUser");
      if (cachedUser != null) {
        final user = UserModel.fromMap(Map<String, dynamic>.from(cachedUser));
        if (user.email == email && user.password == password) {
          return user;
        }
      }
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
    await _userBox.delete("currentUser");
  }

  UserModel? getCurrentUser() {
    final cachedUser = _userBox.get("currentUser");
    if (cachedUser != null) {
      return UserModel.fromMap(Map<String, dynamic>.from(cachedUser));
    }
    return null;
  }
}
