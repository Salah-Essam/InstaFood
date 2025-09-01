
class UserModel {
  String? id; 
  String fullName;
  String email;
  String phone;
  String dateOfBirth;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
  });

  factory UserModel.fromFirestoreDoc(String docId, Map<String, dynamic> data) => UserModel(
        id: data['uid'] as String? ?? data['id'] as String? ?? docId,
        fullName: data['full_name'] as String? ?? '',
        email: data['email'] as String? ?? '',
        phone: data['phone'] as String? ?? '',
        dateOfBirth: data['date_of_birth'] as String? ?? '',
      );

  Map<String, dynamic> toPublicMap() => {
        'uid': id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'date_of_birth': dateOfBirth,
      };
}
