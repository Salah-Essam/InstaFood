
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
	final FirebaseAuth _auth;
	FirebaseAuthService({FirebaseAuth? firebaseAuth}) : _auth = firebaseAuth ?? FirebaseAuth.instance;

	Stream<User?> authStateChanges() => _auth.authStateChanges();

	User? get currentUser => _auth.currentUser;

	Future<UserCredential> signUp({required String email, required String password}) {
		return _auth.createUserWithEmailAndPassword(email: email, password: password);
	}

	Future<UserCredential> signIn({required String email, required String password}) {
		return _auth.signInWithEmailAndPassword(email: email, password: password);
	}

	Future<void> signOut() => _auth.signOut();

	Future<void> sendPasswordResetEmail(String email) => _auth.sendPasswordResetEmail(email: email);

	Future<void> updatePassword(String newPassword) async {
		final user = _auth.currentUser;
		if (user != null) await user.updatePassword(newPassword);
	}

	Future<String?> getIdToken() async {
		final user = _auth.currentUser;
		if (user == null) return null;
		return user.getIdToken();
	}
}
