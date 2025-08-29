import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String? id;
  
  @HiveField(1)
  String fullName;
  
  @HiveField(2)
  String email;
  
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

  //Create a UserModel from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] as String? ?? '',
      fullName: data['full_name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      dateOfBirth: data['date_of_birth'] as String? ?? '',
      password: data['password'] as String? ?? '', // Now we get password from Firestore
    );
  }

  // Create a UserModel from Map (for Hive)
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

  // Convert UserModel to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'password': password,
    };
  }

  // Convert to Map for Firestore (with password)
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'password': password, // Store password in Firestore
    };
  }
}
