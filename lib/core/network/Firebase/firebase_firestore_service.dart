import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/auth/data/model/user_model.dart';

class FirebaseFirestoreService {
	final FirebaseFirestore _db;
	FirebaseFirestoreService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

	CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');

	Future<void> addUser(UserModel user) async {
		if (user.id == null) throw ArgumentError('User id is required to add user');
		await _users.doc(user.id).set({
			...user.toPublicMap(),
			'createdAt': FieldValue.serverTimestamp(),
			'lastLoginAt': FieldValue.serverTimestamp(),
			'deviceTokens': FieldValue.arrayUnion([]),
		}, SetOptions(merge: true));
	}

	Future<UserModel?> getUserByEmail(String email) async {
		final snap = await _users.where('email', isEqualTo: email).limit(1).get();
		if (snap.docs.isEmpty) return null;
		final doc = snap.docs.first;
		return UserModel.fromFirestoreDoc(doc.id, doc.data());
	}

	Future<UserModel?> getUserById(String uid) async {
		final doc = await _users.doc(uid).get();
		if (!doc.exists) return null;
		return UserModel.fromFirestoreDoc(doc.id, doc.data()!);
	}

	Future<void> updateUser(String uid, Map<String, dynamic> data) async {
		await _users.doc(uid).update(data);
	}

	Future<void> touchLastLogin(String uid) async {
		await _users.doc(uid).update({'lastLoginAt': FieldValue.serverTimestamp()});
	}

	Future<void> addDeviceToken(String uid, String token) async {
		await _users.doc(uid).update({'deviceTokens': FieldValue.arrayUnion([token])});
	}

	Future<void> removeDeviceToken(String uid, String token) async {
		await _users.doc(uid).update({'deviceTokens': FieldValue.arrayRemove([token])});
	}

	Future<void> updateDefaultAddress(String uid, Map<String, dynamic> address) async {
		await _users.doc(uid).update({'defaultAddress': address});
	}

	Future<void> deleteUser(String uid) async {
		await _users.doc(uid).delete();
	}
}
