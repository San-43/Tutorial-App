import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const _kUserMapKey = 'user_data_map';

  /// fetches the current Firebase user’s ID token
  static Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  /// reads the entire map from SharedPreferences (token → dynamic)
  static Future<Map<String, dynamic>> _readMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kUserMapKey);
    if (jsonString == null) return {};
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// writes the entire map back to SharedPreferences
  static Future<void> _writeMap(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserMapKey, jsonEncode(map));
  }

  /// public: store arbitrary [value] under the current user’s token
  static Future<void> setCurrentUserData(dynamic value) async {
    final token = await _getToken();
    if (token == null) throw Exception("No logged‑in user");
    final map = await _readMap();
    map[token] = value;
    await _writeMap(map);
  }

  /// public: retrieve the value stored under the current user’s token
  static Future<dynamic> getCurrentUserData() async {
    final token = await _getToken();
    if (token == null) return null;
    final map = await _readMap();
    return map[token];
  }

  /// public: clear the entry for the current user
  static Future<void> removeCurrentUserData() async {
    final token = await _getToken();
    if (token == null) return;
    final map = await _readMap();
    map.remove(token);
    await _writeMap(map);
  }
}
