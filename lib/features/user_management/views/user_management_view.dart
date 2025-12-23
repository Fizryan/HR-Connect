import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/user_management/controllers/user_management_controller.dart';
import 'package:hr_connect/features/user_management/views/add_edit_user_view.dart';
import 'package:provider/provider.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  State<UserManagementView> createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
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
              title: 'User Management',
              subtitle: 'Manage employee accounts',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditUserView()),
        ),
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AppSearchBar(
      hintText: 'Search users...',
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
          return const LoadingState(message: 'Loading users...');
        }

        if (controller.users.isEmpty) {
          return const EmptyState(
            icon: Icons.people_outline,
            title: 'No users found',
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
                    builder: (_) => AddEditUserView(user: user),
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
          ],
        ),
      ),
    );
  }
}
