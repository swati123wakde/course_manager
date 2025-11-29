import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../models/course.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._internal();

  DatabaseService._internal();

  factory DatabaseService() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.coursesTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        numberOfLessons INTEGER NOT NULL,
        score INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
  }

  // Insert Course
  Future<int> insertCourse(Course course) async {
    final db = await database;
    return await db.insert(
      AppConstants.coursesTable,
      course.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get All Courses
  Future<List<Course>> getAllCourses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.coursesTable,
      orderBy: 'updatedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Course.fromMap(maps[i]);
    });
  }

  // Get Course by ID
  Future<Course?> getCourseById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.coursesTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Course.fromMap(maps.first);
  }

  // Update Course
  Future<int> updateCourse(Course course) async {
    final db = await database;
    return await db.update(
      AppConstants.coursesTable,
      course.toMap(),
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  // Delete Course
  Future<int> deleteCourse(String id) async {
    final db = await database;
    return await db.delete(
      AppConstants.coursesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search Courses
  Future<List<Course>> searchCourses(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.coursesTable,
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'updatedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Course.fromMap(maps[i]);
    });
  }

  // Filter Courses by Category
  Future<List<Course>> getCoursesByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.coursesTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'updatedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Course.fromMap(maps[i]);
    });
  }

  // Get Course Count
  Future<int> getCourseCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.coursesTable}');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Delete All Courses
  Future<int> deleteAllCourses() async {
    final db = await database;
    return await db.delete(AppConstants.coursesTable);
  }

  // Close Database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}