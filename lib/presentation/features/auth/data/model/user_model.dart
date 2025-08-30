import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// User profile model.
///
/// NOTE: Password should NEVER be stored in Firestore. We only keep it
/// locally (optionally) for offline forms; FirebaseAuth is the source of truth.
@HiveType(typeId: 1)
class UserModel {
  /// Firebase Auth UID (and Firestore document id)
  @HiveField(0)
  String? id;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  /// Plain password is kept only in Hive for legacy/offline usage. Avoid using.
  @HiveField(3)
  String password;

  @HiveField(4)
  String phone;

  @HiveField(5)
  String dateOfBirth;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.dateOfBirth,
  });

  /// Create a UserModel from Firestore data + doc id.
  factory UserModel.fromFirestoreDoc(String docId, Map<String, dynamic> data) {
    return UserModel(
      id: data['uid'] as String? ?? data['id'] as String? ?? docId,
      fullName: data['full_name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      dateOfBirth: data['date_of_birth'] as String? ?? '',
      password: '',
    );
  }

  /// Create a UserModel from a generic map (Hive cache).
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] as String? ?? '',
      fullName: data['full_name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      dateOfBirth: data['date_of_birth'] as String? ?? '',
      password: data['password'] as String? ?? '',
    );
  }

  /// Convert to map for local (Hive) storage (includes password field).
  Map<String, dynamic> toMap() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'date_of_birth': dateOfBirth,
        'password': password,
      };

  /// Public profile map for Firestore (NO password).
  Map<String, dynamic> toPublicMap() => {
        'uid': id, 
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'date_of_birth': dateOfBirth,
      };
}
