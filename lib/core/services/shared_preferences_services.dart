import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyId = 'id';
  static const String _langId = 'lang';

  // Singleton pattern to ensure only one instance of SharedPreferencesService
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();

  SharedPreferencesService._internal();

  factory SharedPreferencesService() => _instance;

  // Save user details to SharedPreferences
  Future<void> saveUserDetails(
      {required String name, required String email, required String id}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyId, id);
  }

  Future<void> saveUserLang({required LanguageOption language}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langId, language.code);
  }

  Future<String> getUserLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString(_langId) ?? "en";
    return lang;
  }

  // Get user name from SharedPreferences
  Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  // Get user email from SharedPreferences
  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Get user id from SharedPreferences
  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyId);
  }

  // Remove user data from SharedPreferences
  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyId);
  }
}
