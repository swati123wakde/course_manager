import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlack = Color(0xFF0A0A0A);
  // static const Color primaryRed = Color(0xFFE63946);
  // static const Color primaryRed = Color(0xFFE63946);
  static const Color primaryRed =Color(0xFF004D40);
  // static const Color darkRed = Color(0xFFB8252F);
  // static const Color darkRed = Color(0xFFB8252F);
  static const Color darkRed = Color(0xFF00695C);
  // static const Color lightRed = Color(0xFFFF5A67);
  // static const Color lightRed = Color(0xFFFF5A67);
  static const Color lightRed = Color(0xFF00796B);

  // Background Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2A2A2A);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF6B6B6B);

  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryRed, darkRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, primaryBlack],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surfaceDark, cardDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStrings {
  // App
  static const String appName = 'Course Manager';

  // Auth
  static const String login = 'login';
  static const String logout = 'logout';
  static const String email = 'email';
  static const String password = 'password';
  static const String emailHint = 'email_hint';
  static const String passwordHint = 'password_hint';
  static const String loginButton = 'login_button';
  static const String welcome = 'welcome';
  static const String welcomeBack = 'welcome_back';
  static const String loginSubtitle = 'login_subtitle';

  // Navigation
  static const String home = 'home';
  static const String profile = 'profile';
  static const String settings = 'settings';

  // Course
  static const String courses = 'courses';
  static const String addCourse = 'add_course';
  static const String editCourse = 'edit_course';
  static const String deleteCourse = 'delete_course';
  static const String courseDetails = 'course_details';
  static const String title = 'title';
  static const String description = 'description';
  static const String category = 'category';
  static const String lessons = 'lessons';
  static const String score = 'score';
  static const String search = 'search';
  static const String filter = 'filter';
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String edit = 'edit';

  // Messages
  static const String noCourses = 'no_courses';
  static const String noCoursesDesc = 'no_courses_desc';
  static const String deleteConfirm = 'delete_confirm';
  static const String deleteMessage = 'delete_message';
  static const String loading = 'loading';
  static const String error = 'error';
  static const String success = 'success';
  static const String offline = 'offline';
  static const String onlineMode = 'online_mode';
  static const String offlineMode = 'offline_mode';

  // Profile
  static const String myProfile = 'my_profile';
  static const String name = 'name';
  static const String editProfile = 'edit_profile';

  // Settings
  static const String language = 'language';
  static const String theme = 'theme';
  static const String notifications = 'notifications';
  static const String about = 'about';
  static const String version = 'version';

  // Validation
  static const String requiredField = 'required_field';
  static const String invalidEmail = 'invalid_email';
  static const String passwordTooShort = 'password_too_short';
}

class AppConstants {
  // API
  static const String baseUrl = 'https://6759e56f099e3090dbe2c3e2.mockapi.io/api/v1';
  static const String categoriesEndpoint = '/categories';
  static const String loginEndpoint = '/login';

  // Storage Keys
  static const String isLoggedInKey = 'is_logged_in';
  static const String userTokenKey = 'user_token';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String languageKey = 'language';
  static const String cachedCategoriesKey = 'cached_categories';

  // Database
  static const String dbName = 'courses.db';
  static const int dbVersion = 1;
  static const String coursesTable = 'courses';

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 500);
  static const Duration longDuration = Duration(milliseconds: 800);

  // Sizes
  static const double borderRadius = 16.0;
  static const double cardElevation = 4.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 80.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
}