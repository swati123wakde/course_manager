import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final int numberOfLessons;
  final int score;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.numberOfLessons,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate score: (length of course title) × (number of lessons)
  static int calculateScore(String title, int numberOfLessons) {
    return title.length * numberOfLessons;
  }

  // From JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      numberOfLessons: json['numberOfLessons'] as int,
      score: json['score'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'numberOfLessons': numberOfLessons,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // From Database Map
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      numberOfLessons: map['numberOfLessons'] as int,
      score: map['score'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  // To Database Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'numberOfLessons': numberOfLessons,
      'score': score,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy with
  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? numberOfLessons,
    int? score,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      numberOfLessons: numberOfLessons ?? this.numberOfLessons,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    numberOfLessons,
    score,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Course(id: $id, title: $title, category: $category, lessons: $numberOfLessons, score: $score)';
  }
}