import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../localization/app_localizations.dart';
import '../providers/course_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/empty_state_widget.dart';
import 'add_edit_course_screen.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(localizations),
              _buildSearchBar(localizations),
              _buildCategoryFilter(),
              Expanded(child: _buildCourseList(localizations)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddCourse(),
        icon: const Icon(Icons.add),
        label: Text(localizations.translate(AppStrings.addCourse)),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.translate(AppStrings.courses),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  return Text(
                    '${provider.courses.length} courses',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: localizations.translate(AppStrings.search),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryRed),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.textSecondary),
            onPressed: () {
              _searchController.clear();
              Provider.of<CourseProvider>(context, listen: false).searchCourses('');
            },
          )
              : null,
        ),
        onChanged: (value) {
          Provider.of<CourseProvider>(context, listen: false).searchCourses(value);
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer2<CategoryProvider, CourseProvider>(
      builder: (context, categoryProvider, courseProvider, child) {
        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: 8,
            ),
            children: [
              _buildFilterChip('All', courseProvider.selectedCategory == null, () {
                courseProvider.filterByCategory(null);
              }),
              const SizedBox(width: 8),
              ...categoryProvider.categories.map((category) {
                final isSelected = courseProvider.selectedCategory == category.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterChip(
                    category.name,
                    isSelected,
                        () => courseProvider.filterByCategory(category.name),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.primaryRed.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryRed : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _buildCourseList(AppLocalizations localizations) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (courseProvider.courses.isEmpty) {
          return EmptyStateWidget(
            title: localizations.translate(AppStrings.noCourses),
            description: "",
            icon: Icons.school_outlined,
            // actionText: localizations.translate(AppStrings.addCourse),
            onActionPressed: _navigateToAddCourse,
          );
        }

        return RefreshIndicator(
          onRefresh: () => courseProvider.loadCourses(),
          child: GridView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: courseProvider.courses.length,
            itemBuilder: (context, index) {
              final course = courseProvider.courses[index];
              return CourseCard(
                course: course,
                onTap: () => _navigateToCourseDetail(course.id),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToAddCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditCourseScreen(),
      ),
    );
  }

  void _navigateToCourseDetail(String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(courseId: courseId),
      ),
    );
  }
}