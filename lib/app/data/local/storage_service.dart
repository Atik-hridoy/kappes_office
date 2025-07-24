import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/log/app_log.dart';
import 'storage_keys.dart';

class LocalStorage {
  static String token = "";
  static String cookie = "";
  static String refreshToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String myAddress = ""; // Address storage
  static String phone = ""; // Phone number storage

  static SharedPreferences? preferences;

  /// Get SharedPreferences instance
  static Future<SharedPreferences> _getStorage() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  /// Load all values from SharedPreferences
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
    myAddress = localStorage.getString(LocalStorageKeys.myAddress) ?? "";
    phone = localStorage.getString(LocalStorageKeys.phone) ?? ""; // ✅ added

    appLog("UserID: $userId", source: "Local Storage", isError: false);
  }

  /// Save String
  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);
  }

  /// Save Bool
  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);
  }

  /// Get String by key
  static Future<String> getString(String key) async {
    final localStorage = await _getStorage();
    return localStorage.getString(key) ?? '';
  }

  /// Optional: Clear everything (on logout)
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

    appLog("🔐 Local storage cleared", source: "LocalStorage", isError: false);
  }
}
