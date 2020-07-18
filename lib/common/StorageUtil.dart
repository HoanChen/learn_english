import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static Future<bool> set(String key, data) async {
    var success = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data is int) {
      prefs.setInt(key, data);
    } else if (data is double) {
      prefs.setDouble(key, data);
    } else if (data is String) {
      prefs.setString(key, data);
    } else if (data is List<String>) {
      prefs.setStringList(key, data);
    } else if (data is bool) {
      prefs.setBool(key, data);
    } else if (data is Map) {
      prefs.setString(key, json.encode(data));
    } else {
      success = false;
    }
    return success;
  }

  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
