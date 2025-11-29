import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Auth
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'email_hint': 'Enter your email',
      'password_hint': 'Enter your password',
      'login_button': 'Sign In',
      'welcome': 'Welcome',
      'welcome_back': 'Welcome Back!',
      'login_subtitle': 'Sign in to continue to Course Manager',

      // Navigation
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',

      // Course
      'courses': 'Courses',
      'add_course': 'Add Course',
      'edit_course': 'Edit Course',
      'delete_course': 'Delete Course',
      'course_details': 'Course Details',
      'title': 'Title',
      'description': 'Description',
      'category': 'Category',
      'lessons': 'Lessons',
      'score': 'Score',
      'search': 'Search courses...',
      'filter': 'Filter',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',

      // Messages
      'no_courses': 'No Courses Yet',
      'no_courses_desc': 'Add your first course to get started',
      'delete_confirm': 'Delete Course?',
      'delete_message': 'Are you sure you want to delete this course?',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'offline': 'Offline',
      'online_mode': 'Online Mode',
      'offline_mode': 'Offline Mode',

      // Profile
      'my_profile': 'My Profile',
      'name': 'Name',
      'edit_profile': 'Edit Profile',

      // Settings
      'language': 'Language',
      'theme': 'Theme',
      'notifications': 'Notifications',
      'about': 'About',
      'version': 'Version',

      // Validation
      'required_field': 'This field is required',
      'invalid_email': 'Please enter a valid email',
      'password_too_short': 'Password must be at least 6 characters',
    },
    'hi': {
      // Auth
      'login': 'लॉगिन',
      'logout': 'लॉगआउट',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'email_hint': 'अपना ईमेल दर्ज करें',
      'password_hint': 'अपना पासवर्ड दर्ज करें',
      'login_button': 'साइन इन करें',
      'welcome': 'स्वागत है',
      'welcome_back': 'वापसी पर स्वागत है!',
      'login_subtitle': 'कोर्स मैनेजर में जारी रखने के लिए साइन इन करें',

      // Navigation
      'home': 'होम',
      'profile': 'प्रोफ़ाइल',
      'settings': 'सेटिंग्स',

      // Course
      'courses': 'कोर्सेज',
      'add_course': 'कोर्स जोड़ें',
      'edit_course': 'कोर्स संपादित करें',
      'delete_course': 'कोर्स हटाएं',
      'course_details': 'कोर्स विवरण',
      'title': 'शीर्षक',
      'description': 'विवरण',
      'category': 'श्रेणी',
      'lessons': 'पाठ',
      'score': 'स्कोर',
      'search': 'कोर्स खोजें...',
      'filter': 'फ़िल्टर',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',

      // Messages
      'no_courses': 'अभी तक कोई कोर्स नहीं',
      'no_courses_desc': 'शुरू करने के लिए अपना पहला कोर्स जोड़ें',
      'delete_confirm': 'कोर्स हटाएं?',
      'delete_message': 'क्या आप वाकई इस कोर्स को हटाना चाहते हैं?',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      'offline': 'ऑफ़लाइन',
      'online_mode': 'ऑनलाइन मोड',
      'offline_mode': 'ऑफ़लाइन मोड',

      // Profile
      'my_profile': 'मेरी प्रोफ़ाइल',
      'name': 'नाम',
      'edit_profile': 'प्रोफ़ाइल संपादित करें',

      // Settings
      'language': 'भाषा',
      'theme': 'थीम',
      'notifications': 'सूचनाएं',
      'about': 'के बारे में',
      'version': 'संस्करण',

      // Validation
      'required_field': 'यह फ़ील्ड आवश्यक है',
      'invalid_email': 'कृपया एक मान्य ईमेल दर्ज करें',
      'password_too_short': 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}