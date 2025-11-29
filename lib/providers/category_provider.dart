import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../services/shared_preferences_service.dart';
import '../services/connectivity_service.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final ConnectivityService _connectivityService = ConnectivityService();

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCategories => _categories.isNotEmpty;

  // Initialize and load categories
  Future<void> initialize() async {
    await loadCategories();
  }

  // Load categories (online first, fallback to cache)
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if online
      final isOnline = await _connectivityService.isConnected();

      if (isOnline) {
        // Try to fetch from API
        try {
          _categories = await _apiService.getCategories();
          // Cache the categories
          await _prefsService.cacheCategories(_categories);
        } catch (e) {
          // If API fails, use cached categories
          _categories = _prefsService.getCachedCategories() ?? [];
        }
      } else {
        // Use cached categories when offline
        _categories = _prefsService.getCachedCategories() ?? [];
      }

      // If no categories at all, use default
      if (_categories.isEmpty) {
        _categories = _getDefaultCategories();
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      _categories = _getDefaultCategories();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refresh categories from API
  Future<void> refreshCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
      await _prefsService.cacheCategories(_categories);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get category by ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get category by name
  Category? getCategoryByName(String name) {
    try {
      return _categories.firstWhere((cat) => cat.name == name);
    } catch (e) {
      return null;
    }
  }

  // Default categories
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

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}