import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_keys.dart';

class LocalStorage {
  static String get myProfileImage =>
      preferences?.getString(LocalStorageKeys.myProfileImage) ?? '';
  static String token = "";
  static String cookie = "";
  static String refreshToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String myAddress = "";
  static String get myPhone => preferences?.getString(LocalStorageKeys.phone) ?? "";
  static String phone = ""; 

  static SharedPreferences? preferences;


  static Future<SharedPreferences> _getStorage() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }


static Future<void> getAllPrefData() async {
  final localStorage = await _getStorage();

  token = localStorage.getString(LocalStorageKeys.token) ?? "";
  cookie = localStorage.getString(LocalStorageKeys.cookie) ?? "";
  refreshToken = localStorage.getString(LocalStorageKeys.refreshToken) ?? "";
  isLogIn = localStorage.getBool(LocalStorageKeys.isLogIn) ?? false;
  userId = localStorage.getString(LocalStorageKeys.userId) ?? "";
  myImage = localStorage.getString(LocalStorageKeys.myImage) ?? "";
  myName = localStorage.getString(LocalStorageKeys.myName) ?? "";
  myEmail = localStorage.getString(LocalStorageKeys.myEmail) ?? "";
  phone = localStorage.getString(LocalStorageKeys.phone) ?? "";

  AppLogger.info(userId, tag: "Local Storage");
  AppLogger.info("Profile Image - myImage: $myImage, myProfileImage: $myProfileImage", tag: "Profile Debug");
}


  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);
  }


  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);
  }


  static Future<String> getString(String key) async {
    final localStorage = await _getStorage();
    return localStorage.getString(key) ?? '';
  }


  static Future<void> clearAll() async {
    final localStorage = await _getStorage();
    await localStorage.clear();

    token = "";
    cookie = "";
    refreshToken = "";
    isLogIn = false;
    userId = "";
    myImage = "";
    myName = "";
    myEmail = "";
    myAddress = "";
    phone = "";

    AppLogger.info("🔐 Local storage cleared");
  }
}
