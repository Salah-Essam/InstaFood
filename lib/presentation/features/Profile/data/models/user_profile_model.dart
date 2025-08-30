class UserProfileModel {
  UserProfileModel({
    required this.name,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
  });
  final String name;
  final DateTime birthDate;
  final String email;
  final String phoneNumber;
}
