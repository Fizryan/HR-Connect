import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';

class MetricsGrid extends ConsumerWidget {
  final DashboardModel dashboard;
  const MetricsGrid({required this.dashboard, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.8,
        children: [
          _buildMetricCard(
            title: 'Attendance Rate',
            value: '${dashboard.attendanceRate}%',
            icon: Icons.percent_outlined,
            colorScheme: colorScheme,
          ),
          _buildMetricCard(
            title: 'Pending Leave',
            value: '${dashboard.pendingLeave}',
            icon: Icons.beach_access_outlined,
            colorScheme: colorScheme,
          ),
          _buildMetricCard(
            title: 'Pending Trip',
            value: '${dashboard.pendingTrip}',
            icon: Icons.business_center_outlined,
            colorScheme: colorScheme,
          ),
          if (dashboard.totalUser != null) ...[
            _buildMetricCard(
              title: 'Total User',
              value: '${dashboard.totalUser}',
              icon: Icons.people_alt_outlined,
              colorScheme: colorScheme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 24.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
