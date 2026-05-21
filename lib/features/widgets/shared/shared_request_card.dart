import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';

class SharedRequestCard extends StatelessWidget {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final RequestStatus status;
  final IconData icon;
  final ColorScheme colorScheme;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const SharedRequestCard({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.icon,
    required this.colorScheme,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;
    if (status == RequestStatus.pending) {
      statusColor = colorScheme.onPrimary;
      statusBgColor = colorScheme.primary;
    } else if (status == RequestStatus.approved) {
      statusColor = colorScheme.onSecondary;
      statusBgColor = colorScheme.secondary;
    } else {
      statusColor = colorScheme.onError;
      statusBgColor = colorScheme.error;
    }

    final isPending = status == RequestStatus.pending;
    final showActions = isPending && (onApprove != null || onReject != null);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Handle item tap
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 24.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 12.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Text(
                      Capitalize.firstLetterUppercase(status.name),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (showActions) ...[
                SizedBox(height: 16.h),
                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    if (onReject != null) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            side: BorderSide(
                              color: colorScheme.error.withValues(alpha: 0.5),
                            ),
                          ),
                          icon: Icon(Icons.close_rounded, size: 18.sp),
                          label: const Text('Reject'),
                        ),
                      ),
                    ],
                    if (onApprove != null && onReject != null) SizedBox(width: 12.w),
                    if (onApprove != null) ...[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onApprove,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                          icon: Icon(Icons.check_rounded, size: 18.sp),
                          label: const Text('Approve'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
