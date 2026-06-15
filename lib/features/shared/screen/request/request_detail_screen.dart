import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/theme/status_color.dart';

class RequestDetailScreen extends StatelessWidget {
  final String requestId;
  final RequestKind requestKind;
  final String type;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final RequestStatus status;

  const RequestDetailScreen({
    super.key,
    required this.requestId,
    required this.requestKind,
    required this.type,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenTitle = requestKind == RequestKind.leave
        ? 'Leave Request'
        : 'Trip Request';

    final durationInDays = endDate.difference(startDate).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          screenTitle,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: StatusColor.getStatusColor(
                  colorScheme,
                  status,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: StatusColor.getStatusColor(
                    colorScheme,
                    status,
                  ).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    StatusColor.getStatusIcon(status),
                    color: StatusColor.getStatusColor(colorScheme, status),
                    size: 40.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    Capitalize.firstLetterUppercase(status.name),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: StatusColor.getStatusColor(colorScheme, status),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Request ID: $requestId',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'monospace',
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Request Information',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            _buildInfoTile(
              context,
              icon: Icons.category_outlined,
              label: 'Category Type',
              value: Capitalize.firstLetterUppercase(type),
            ),
            _buildInfoTile(
              context,
              icon: Icons.description_outlined,
              label: 'Description',
              value: description,
            ),
            SizedBox(height: 14.h),
            Text(
              'Schedule Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            _buildInfoTile(
              context,
              icon: Icons.calendar_today_rounded,
              label: 'Start Date',
              value: '${startDate.day}/${startDate.month}/${startDate.year}',
            ),
            _buildInfoTile(
              context,
              icon: Icons.event_rounded,
              label: 'End Date',
              value: '${endDate.day}/${endDate.month}/${endDate.year}',
            ),
            _buildInfoTile(
              context,
              icon: Icons.timer_outlined,
              label: 'Duration',
              value: '$durationInDays Day(s)',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 12.h),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            indent: 56.w,
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}
