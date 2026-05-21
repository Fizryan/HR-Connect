import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/business_trip/data/model/business_trip_model.dart';
import 'package:hr_connect/features/business_trip/provider/business_provider.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/widgets/presentation/features/etc/about_screen.dart';
import 'package:hr_connect/features/widgets/presentation/features/etc/edit_profile_screen.dart';
import 'package:hr_connect/features/widgets/presentation/features/etc/support_screen.dart';
import 'package:hr_connect/features/widgets/presentation/features/etc/theme_screen.dart';
import 'package:hr_connect/features/widgets/shared/bubble_particle.dart';

class DashboardScreen extends ConsumerWidget {
  final UserModel user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final leaveState = ref.watch(leaveNotifierProvider);
    final businessTripState = ref.watch(businessNotifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          const BubbleField(particleCount: 6),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  ref
                      .read(leaveNotifierProvider.notifier)
                      .refreshLeaveRequests(),
                  ref
                      .read(businessNotifierProvider.notifier)
                      .refreshBusinessTrip(),
                ]);
              },
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(colorScheme, context, ref),
                    SizedBox(height: 32.h),
                    _buildSectionHeader(
                      title: 'Recent Leaves',
                      showSeeAll:
                          leaveState.hasValue && leaveState.value!.isNotEmpty,
                      onSeeAll: () {
                        // TODO: Implement see all leaves
                      },
                      colorScheme: colorScheme,
                    ),
                    leaveState.when(
                      loading: _buildLoadingState,
                      error: (err, _) =>
                          _buildErrorCard(err.toString(), colorScheme),
                      data: (leaves) => _buildRecentList<LeaveRequestModel>(
                        items: leaves,
                        emptyMessage: 'No recent leave requests',
                        emptyIcon: Icons.inbox_rounded,
                        colorScheme: colorScheme,
                        itemBuilder: (leave) => _buildStatusCard(
                          title: Capitalize.firstLetterUppercase(
                            leave.leaveType.name,
                          ),
                          subtitle:
                              '${leave.startDate.day}/${leave.startDate.month} - ${leave.endDate.day}/${leave.endDate.month}',
                          icon: Icons.beach_access_rounded,
                          status: leave.status,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    _buildSectionHeader(
                      title: 'Recent Business Trips',
                      showSeeAll:
                          businessTripState.hasValue &&
                          businessTripState.value!.isNotEmpty,
                      onSeeAll: () {
                        // TODO: Implement see all business trips
                      },
                      colorScheme: colorScheme,
                    ),
                    businessTripState.when(
                      loading: _buildLoadingState,
                      error: (err, _) =>
                          _buildErrorCard(err.toString(), colorScheme),
                      data: (trips) => _buildRecentList<BusinessTripModel>(
                        items: trips,
                        emptyMessage: 'No recent business trips',
                        emptyIcon: Icons.business_rounded,
                        colorScheme: colorScheme,
                        itemBuilder: (trip) => _buildStatusCard(
                          title: Capitalize.firstLetterUppercase(
                            trip.businessTripType.name,
                          ),
                          subtitle:
                              '${trip.startDate.day}/${trip.startDate.month} - ${trip.endDate.day}/${trip.endDate.month}',
                          icon: Icons.business_center_rounded,
                          status: trip.status,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool showSeeAll,
    required VoidCallback onSeeAll,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          if (showSeeAll)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: const Text('See All'),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentList<T>({
    required List<T> items,
    required String emptyMessage,
    required IconData emptyIcon,
    required ColorScheme colorScheme,
    required Widget Function(T item) itemBuilder,
  }) {
    if (items.isEmpty) {
      return _buildEmptyState(emptyMessage, emptyIcon, colorScheme);
    }

    final recentItems = items.take(3).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => itemBuilder(recentItems[index]),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required RequestStatus status,
    required ColorScheme colorScheme,
  }) {
    Color statusBgColor;
    Color statusTextColor;

    if (status == RequestStatus.approved) {
      statusBgColor = Colors.green.withValues(alpha: 0.15);
      statusTextColor = Colors.green.shade700;
    } else if (status == RequestStatus.pending) {
      statusBgColor = colorScheme.primaryContainer;
      statusTextColor = colorScheme.onPrimaryContainer;
    } else {
      statusBgColor = colorScheme.errorContainer;
      statusTextColor = colorScheme.error;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20.sp, color: colorScheme.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              Capitalize.firstLetterUppercase(status.name),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState(
    String message,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40.sp,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colorScheme.error),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: colorScheme.error, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    ColorScheme colorScheme,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: user.avatarUrl ?? '',
            imageBuilder: (context, imageProvider) =>
                CircleAvatar(radius: 22.r, backgroundImage: imageProvider),
            placeholder: (context, url) => _buildFallbackAvatar(colorScheme),
            errorWidget: (context, url, error) =>
                _buildFallbackAvatar(colorScheme),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName.isNotEmpty ? '${user.lastName[0].toUpperCase()}.' : ''}'
                      .trim(),
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  Capitalize.firstLetterUppercase(user.role.name),
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _buildSettingsMenu(context, ref, colorScheme),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar(ColorScheme colorScheme) {
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildSettingsMenu(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      position: PopupMenuPosition.under,
      color: colorScheme.surfaceContainerLowest,
      onSelected: (value) {
        switch (value) {
          case 'edit_profile':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
            );
            break;
          case 'about':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            );
            break;
          case 'theme':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemeScreen()),
            );
            break;
          case 'support':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupportScreen()),
            );
            break;
          case 'logout':
            _showLogoutDialog(context, ref, colorScheme);
            break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(
          'edit_profile',
          Icons.person_outline_rounded,
          'Edit Profile',
          colorScheme.onSurface,
        ),
        _buildMenuItem(
          'theme',
          Icons.palette_outlined,
          'Theme Mode',
          colorScheme.onSurface,
        ),
        _buildMenuItem(
          'support',
          Icons.support_agent_outlined,
          'Support',
          colorScheme.onSurface,
        ),
        _buildMenuItem(
          'about',
          Icons.info_outline_rounded,
          'About',
          colorScheme.onSurface,
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          'logout',
          Icons.logout_rounded,
          'Logout',
          colorScheme.error,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to end your session?',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(context);
                ref.read(authNotifierProvider.notifier).logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
