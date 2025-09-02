import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_food/presentation/features/auth/data/model/user_model.dart';

/// Manages the persisted authenticated user session (token + non-sensitive user info).
class SessionManager {
  static const _keyUser = 'session_user';
  static const _keyToken = 'session_token';

  final SharedPreferences prefs;
  SessionManager({required this.prefs});

  Future<void> storeSession({required UserModel user, String? token}) async {
    final userMap = user.toPublicMap();
    await prefs.setString(_keyUser, jsonEncode(userMap));
    if (token != null) {
      await prefs.setString(_keyToken, token);
    }
  }

  UserModel? getUser() {
    final jsonString = prefs.getString(_keyUser);
    if (jsonString == null) return null;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel(
        id: (map['uid'] ?? map['id']) as String?,
        fullName: (map['full_name'] ?? '') as String,
        email: (map['email'] ?? '') as String,
        phone: (map['phone'] ?? '') as String,
        dateOfBirth: (map['date_of_birth'] ?? '') as String,
      );
    } catch (_) {
      return null;
    }
  }

  String? getToken() => prefs.getString(_keyToken);

  Future<void> clear() async {
    await prefs.remove(_keyUser);
    await prefs.remove(_keyToken);
  }
}
