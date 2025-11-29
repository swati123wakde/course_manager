import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';
import '../providers/course_provider.dart';
import '../providers/category_provider.dart';
import '../models/course.dart';
import '../widgets/gradient_button.dart';

class AddEditCourseScreen extends StatefulWidget {
  final String? courseId;

  const AddEditCourseScreen({super.key, this.courseId});

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lessonsController = TextEditingController();
  String? _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.courseId != null) {
      _loadCourse();
    }
  }

  Future<void> _loadCourse() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final course = await courseProvider.getCourseById(widget.courseId!);

    if (course != null) {
      setState(() {
        _titleController.text = course.title;
        _descriptionController.text = course.description;
        _lessonsController.text = course.numberOfLessons.toString();
        _selectedCategory = course.category;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _lessonsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      setState(() => _isLoading = true);

      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      bool success;

      if (widget.courseId == null) {
        success = await courseProvider.addCourse(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory!,
          numberOfLessons: int.parse(_lessonsController.text),
        );
      } else {
        success = await courseProvider.updateCourse(
          id: widget.courseId!,
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory!,
          numberOfLessons: int.parse(_lessonsController.text),
        );
      }

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course saved successfully'), backgroundColor: AppColors.success),
        );
      }
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isEdit = widget.courseId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate(isEdit ? AppStrings.editCourse : AppStrings.addCourse)),
        backgroundColor: AppColors.backgroundDark,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: localizations.translate(AppStrings.title),
                      prefixIcon: const Icon(Icons.title, color: AppColors.primaryRed),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate(AppStrings.requiredField);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: localizations.translate(AppStrings.description),
                      prefixIcon: const Icon(Icons.description, color: AppColors.primaryRed),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate(AppStrings.requiredField);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<CategoryProvider>(
                    builder: (context, categoryProvider, child) {
                      return DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        style: const TextStyle(color: AppColors.textPrimary),
                        dropdownColor: AppColors.surfaceDark,
                        decoration: InputDecoration(
                          labelText: localizations.translate(AppStrings.category),
                          prefixIcon: const Icon(Icons.category, color: AppColors.primaryRed),
                        ),
                        items: categoryProvider.categories.map((category) {
                          return DropdownMenuItem(
                            value: category.name,
                            child: Text('${category.icon ?? ''} ${category.name}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return localizations.translate(AppStrings.requiredField);
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lessonsController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: localizations.translate(AppStrings.lessons),
                      prefixIcon: const Icon(Icons.book, color: AppColors.primaryRed),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate(AppStrings.requiredField);
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    onPressed: _isLoading ? null : _saveCourse,
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(localizations.translate(AppStrings.save)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}