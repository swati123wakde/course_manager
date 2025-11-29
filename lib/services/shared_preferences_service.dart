import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../models/category.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;
  static final SharedPreferencesService instance = SharedPreferencesService._internal();

  SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return instance;
  }

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_preferences == null) {
      throw Exception('SharedPreferences not initialized. Call init() first.');
    }
    return _preferences!;
  }

  // Auth Methods
  Future<bool> setLoggedIn(bool value) async {
    return await prefs.setBool(AppConstants.isLoggedInKey, value);
  }

  bool isLoggedIn() {
    return prefs.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  Future<bool> setUserToken(String token) async {
    return await prefs.setString(AppConstants.userTokenKey, token);
  }

  String? getUserToken() {
    return prefs.getString(AppConstants.userTokenKey);
  }

  Future<bool> setUserName(String name) async {
    return await prefs.setString(AppConstants.userNameKey, name);
  }

  String? getUserName() {
    return prefs.getString(AppConstants.userNameKey);
  }

  Future<bool> setUserEmail(String email) async {
    return await prefs.setString(AppConstants.userEmailKey, email);
  }

  String? getUserEmail() {
    return prefs.getString(AppConstants.userEmailKey);
  }

  Future<bool> saveUser(User user) async {
    await setUserName(user.name);
    await setUserEmail(user.email);
    if (user.token != null) {
      await setUserToken(user.token!);
    }
    return await setLoggedIn(true);
  }

  User? getUser() {
    if (!isLoggedIn()) return null;

    final name = getUserName();
    final email = getUserEmail();
    final token = getUserToken();

    if (name == null || email == null) return null;

    return User(
      id: email.hashCode.toString(),
      name: name,
      email: email,
      token: token,
    );
  }

  Future<bool> clearUser() async {
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userNameKey);
    await prefs.remove(AppConstants.userEmailKey);
    return await setLoggedIn(false);
  }

  // Language Methods
  Future<bool> setLanguage(String languageCode) async {
    return await prefs.setString(AppConstants.languageKey, languageCode);
  }

  String getLanguage() {
    return prefs.getString(AppConstants.languageKey) ?? 'en';
  }

  // Category Cache Methods
  Future<bool> cacheCategories(List<Category> categories) async {
    final jsonList = categories.map((c) => json.encode(c.toJson())).toList();
    return await prefs.setStringList(AppConstants.cachedCategoriesKey, jsonList);
  }

  List<Category>? getCachedCategories() {
    final jsonList = prefs.getStringList(AppConstants.cachedCategoriesKey);
    if (jsonList == null) return null;

    return jsonList.map((jsonStr) {
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;
      return Category.fromJson(jsonMap);
    }).toList();
  }

  // Clear All Data
  Future<bool> clearAll() async {
    return await prefs.clear();
  }
}