import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/presentation/features/auth/data/model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Box _userBox;

  AuthRepository(this._firebaseAuth, this._firestore, this._userBox);

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

    final user = UserModel(
      id: userCredential.user!.uid,
      fullName: fullName,
      email: email,
      password: password,
      dateOfBirth: dateOfBirth,
      phone: phone,
    );

    // Save to Firestore (with password)
    await _firestore.collection("users").doc(user.id).set(user.toFirestoreMap());

    // Save locally with password for offline access
    await _userBox.put("currentUser", user.toMap());

    return user;
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      // Try to find user by email in Firestore and check password
      final querySnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final user = UserModel.fromFirestore(userData);
        
        // Check if password matches
        if (user.password == password) {
          // Try Firebase Auth login (might fail if password was changed via Firestore)
          try {
            await _firebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
          } catch (_) {
            // Firebase Auth failed but Firestore password matched, continue
          }
          
          await _userBox.put("currentUser", user.toMap());
          return user;
        }
      }
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

  Future<void> setPassword(String newPassword) async {
    final cachedUser = _userBox.get("currentUser");
    if (cachedUser != null) {
      final user = UserModel.fromMap(Map<String, dynamic>.from(cachedUser));
      
      // Try to update Firebase Auth password if user is logged in
      final firebaseUser = _firebaseAuth.currentUser;
      try {
        if (firebaseUser != null && firebaseUser.uid == user.id) {
          await firebaseUser.updatePassword(newPassword);
        }
      } catch (_) {
        // Firebase Auth update failed, but continue with Firestore update
      }

      final updatedUser = UserModel(
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        password: newPassword,
        dateOfBirth: user.dateOfBirth,
        phone: user.phone,
      );

      await _userBox.put("currentUser", updatedUser.toMap());
      // Update Firestore (with password)
      await _firestore.collection("users").doc(user.id).update(updatedUser.toFirestoreMap());
    }
  }

  // New method to change password by email (for forgot password functionality)
  Future<bool> changePasswordByEmail(String email, String newPassword) async {
    try {
      final querySnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final userData = doc.data();
        final user = UserModel.fromFirestore(userData);
        
        final updatedUser = UserModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          password: newPassword,
          dateOfBirth: user.dateOfBirth,
          phone: user.phone,
        );

        // Update Firestore
        await _firestore.collection("users").doc(doc.id).update(updatedUser.toFirestoreMap());
        
        // Try to update Firebase Auth password if user exists
        try {
          final firebaseUser = _firebaseAuth.currentUser;
          if (firebaseUser != null && firebaseUser.uid == user.id) {
            await firebaseUser.updatePassword(newPassword);
          }
        } catch (_) {
          // Firebase Auth update failed, but Firestore was updated
        }
        
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  // Check if user exists by email
  Future<bool> userExistsByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();
      
      return querySnapshot.docs.isNotEmpty;
    } catch (_) {
      return false;
    }
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
