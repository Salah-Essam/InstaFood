import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseFirestoreService {
final FirebaseFirestore _db = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> get users => _db.collection('users');


Future<void> setUser(String uid, Map<String, dynamic> data) async {
await users.doc(uid).set(data, SetOptions(merge: true));
}


Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) {
return users.doc(uid).get();
}
}