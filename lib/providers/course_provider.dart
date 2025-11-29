import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/database_service.dart';

class CourseProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;

  List<Course> get courses => _filteredCourses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  bool get hasCourses => _courses.isNotEmpty;

  // Initialize and load courses
  Future<void> initialize() async {
    await loadCourses();
  }

  // Load all courses
  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _courses = await _dbService.getAllCourses();
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add course
  Future<bool> addCourse({
    required String title,
    required String description,
    required String category,
    required int numberOfLessons,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final score = Course.calculateScore(title, numberOfLessons);
      final now = DateTime.now();

      final course = Course(
        id: now.millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        category: category,
        numberOfLessons: numberOfLessons,
        score: score,
        createdAt: now,
        updatedAt: now,
      );

      await _dbService.insertCourse(course);
      await loadCourses();

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update course
  Future<bool> updateCourse({
    required String id,
    required String title,
    required String description,
    required String category,
    required int numberOfLessons,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final existingCourse = await _dbService.getCourseById(id);
      if (existingCourse == null) {
        throw Exception('Course not found');
      }

      final score = Course.calculateScore(title, numberOfLessons);

      final updatedCourse = existingCourse.copyWith(
        title: title,
        description: description,
        category: category,
        numberOfLessons: numberOfLessons,
        score: score,
        updatedAt: DateTime.now(),
      );

      await _dbService.updateCourse(updatedCourse);
      await loadCourses();

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete course
  Future<bool> deleteCourse(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.deleteCourse(id);
      await loadCourses();

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get course by ID
  Future<Course?> getCourseById(String id) async {
    try {
      return await _dbService.getCourseById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Search courses
  void searchCourses(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _applyFilters();
    notifyListeners();
  }

  // Apply search and category filters
  void _applyFilters() {
    _filteredCourses = _courses.where((course) {
      final matchesSearch = _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == null ||
          _selectedCategory == 'All' ||
          course.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Get course count
  Future<int> getCourseCount() async {
    try {
      return await _dbService.getCourseCount();
    } catch (e) {
      return 0;
    }
  }

  // Get courses by category count
  Map<String, int> getCourseCountByCategory() {
    final Map<String, int> counts = {};
    for (var course in _courses) {
      counts[course.category] = (counts[course.category] ?? 0) + 1;
    }
    return counts;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}