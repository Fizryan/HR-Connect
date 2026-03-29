import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/model/list_overview.dart';

class OverviewWidgets extends StatelessWidget {
  final ColorScheme colorScheme;
  final String title;
  final List<ListOverview> listOverview;

  const OverviewWidgets({
    super.key,
    required this.colorScheme,
    required this.title,
    required this.listOverview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Wrap(
              spacing: 16.w,
              runSpacing: 24.h,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: listOverview
                  .map(
                    (overview) => SizedBox(
                      width: (MediaQuery.of(context).size.width - 130.w) / 5,
                      child: _buildListIcon(overview),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListIcon(ListOverview overview) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48.w,
          width: 48.w,
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(overview.icon, color: overview.iconColor, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          overview.subtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12.sp,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          overview.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 12.sp,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
