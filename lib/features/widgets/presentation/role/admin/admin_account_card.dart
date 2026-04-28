import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';

class AdminAccountCard extends StatelessWidget {
  final AccountModel account;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const AdminAccountCard({
    super.key,
    required this.account,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 48.sp,
                color: colorScheme.primary,
              ),
              SizedBox(height: 12.h),
              Text(
                account.email,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'UID: ${account.uid.isNotEmpty ? (account.uid.length > 8 ? '${account.uid.substring(0, 8)}...' : account.uid) : 'N/A'}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}