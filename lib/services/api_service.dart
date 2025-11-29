import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/user.dart';
import '../models/category.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();

  ApiService._internal();

  factory ApiService() {
    return instance;
  }

  final String baseUrl = AppConstants.baseUrl;

  // Login
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${AppConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      // Mock login for offline testing
      return User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@')[0],
        email: email,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  // Get Categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${AppConstants.categoriesEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // Return default categories if API fails
      return _getDefaultCategories();
    }
  }

  // Default categories for offline mode
  List<Category> _getDefaultCategories() {
    return [
      const Category(id: '1', name: 'Programming', icon: '💻'),
      const Category(id: '2', name: 'Design', icon: '🎨'),
      const Category(id: '3', name: 'Business', icon: '💼'),
      const Category(id: '4', name: 'Marketing', icon: '📊'),
      const Category(id: '5', name: 'Photography', icon: '📷'),
      const Category(id: '6', name: 'Music', icon: '🎵'),
      const Category(id: '7', name: 'Fitness', icon: '💪'),
      const Category(id: '8', name: 'Language', icon: '🌍'),
      const Category(id: '9', name: 'Science', icon: '🔬'),
      const Category(id: '10', name: 'Mathematics', icon: '🔢'),
    ];
  }

  // Check server health
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}