import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/user_management/controllers/user_management_controller.dart';
import 'package:hr_connect/features/user_management/views/add_edit_user_view.dart';
import 'package:provider/provider.dart';

class HrdUserManagementView extends StatefulWidget {
  const HrdUserManagementView({super.key});

  @override
  State<HrdUserManagementView> createState() => _HrdUserManagementViewState();
}

class _HrdUserManagementViewState extends State<HrdUserManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<UserManagementController>();
      if (!controller.hasData) {
        controller.fetchUsers(forceRefresh: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Employee Management',
              subtitle: 'View and update employee data',
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'HRD can only view and update employee data. Contact Admin to create new users.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _buildSearchBar(context),
            SizedBox(height: 16.h),
            _buildFilterChips(context),
            SizedBox(height: 16.h),
            Expanded(child: _buildUserList(context, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AppSearchBar(
      hintText: 'Search employees...',
      onChanged: (val) =>
          context.read<UserManagementController>().setSearchQuery(val),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Consumer<UserManagementController>(
      builder: (context, controller, _) {
        return AppFilterChips(
          filters: const ['All', 'Active', 'Inactive'],
          currentFilter: controller.currentFilter,
          onFilterChanged: controller.setFilter,
        );
      },
    );
  }

  Widget _buildUserList(BuildContext context, ThemeData theme) {
    return Consumer<UserManagementController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const LoadingState(message: 'Loading employees...');
        }

        if (controller.users.isEmpty) {
          return const EmptyState(
            icon: Icons.people_outline,
            title: 'No employees found',
            subtitle: 'Try adjusting your search or filters',
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchUsers(forceRefresh: true),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              return _UserCard(
                user: user,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddEditUserView(user: user, isHrdMode: true),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const _UserCard({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = user.status.toLowerCase() == 'active'
        ? AppColors.success
        : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                user.fullname.isNotEmpty ? user.fullname[0].toUpperCase() : '?',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullname,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(
                  label: user.status.toUpperCase(),
                  color: statusColor,
                ),
                SizedBox(height: 4.h),
                Text(
                  user.role.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.edit_outlined,
              size: 20.sp,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
