import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';
import '../providers/course_provider.dart';
import '../models/course.dart';
import 'add_edit_course_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Course? _course;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final course = await courseProvider.getCourseById(widget.courseId);
    setState(() => _course = course);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    if (_course == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_course!.title),
                background: Container(
                  decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                  child: const Icon(Icons.school, size: 80, color: Colors.white54),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _course!.category,
                            style: const TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.warning),
                              const SizedBox(width: 4),
                              Text(
                                _course!.score.toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(_course!.description, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.book, 'Lessons', '${_course!.numberOfLessons} Lessons'),
                            const Divider(),
                            _buildInfoRow(Icons.calendar_today, 'Created', DateFormat.yMMMd().format(_course!.createdAt)),
                            const Divider(),
                            _buildInfoRow(Icons.update, 'Updated', DateFormat.yMMMd().format(_course!.updatedAt)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _editCourse(context),
                            icon: const Icon(Icons.edit),
                            label: Text(localizations.translate(AppStrings.edit)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _deleteCourse(context),
                            icon: const Icon(Icons.delete),
                            label: Text(localizations.translate(AppStrings.delete)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Future<void> _editCourse(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditCourseScreen(courseId: widget.courseId),
      ),
    );
    _loadCourse();
  }

  Future<void> _deleteCourse(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.translate(AppStrings.deleteConfirm)),
        content: Text(localizations.translate(AppStrings.deleteMessage)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations.translate(AppStrings.cancel)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations.translate(AppStrings.delete)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      await courseProvider.deleteCourse(widget.courseId);
      Navigator.pop(context);
    }
  }
}