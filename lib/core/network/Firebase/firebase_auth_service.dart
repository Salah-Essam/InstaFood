
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
final FirebaseAuth _auth = FirebaseAuth.instance;


Stream<User?> authStateChanges() => _auth.authStateChanges();


User? get currentUser => _auth.currentUser;


Future<UserCredential> signUpWithEmail(String email, String password) {
return _auth.createUserWithEmailAndPassword(email: email, password: password);
}


Future<UserCredential> loginWithEmail(String email, String password) {
return _auth.signInWithEmailAndPassword(email: email, password: password);
}


Future<void> sendEmailVerification() async {
final user = _auth.currentUser;
if (user != null && !user.emailVerified) await user.sendEmailVerification();
}


Future<void> sendPasswordReset(String email) {
return _auth.sendPasswordResetEmail(email: email);
}


Future<void> logout() => _auth.signOut();


Future<void> updatePassword(String newPassword) async {
final user = _auth.currentUser;
if (user != null) await user.updatePassword(newPassword);
}
}