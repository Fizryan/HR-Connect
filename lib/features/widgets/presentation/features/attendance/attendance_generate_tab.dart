import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';

class AttendanceGenerateTab extends ConsumerWidget {
  const AttendanceGenerateTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final userState = ref.watch(authNotifierProvider);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Personal QR Code',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Show this QR code to the scanner device to check in or out.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: userState.when(
                loading: () => SizedBox(
                  height: 200.w,
                  width: 200.w,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => SizedBox(
                  height: 200.w,
                  width: 200.w,
                  child: Center(
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: colorScheme.error,
                      size: 48.sp,
                    ),
                  ),
                ),
                data: (user) {
                  // placeholder image or a generic QR endpoint
                  final qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=${user?.id ?? "unknown"}';

                  return CachedNetworkImage(
                    imageUrl: qrUrl,
                    width: 200.w,
                    height: 200.w,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_rounded,
                            size: 64.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'QR not available',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),
            userState.maybeWhen(
              data: (user) => Text(
                user?.fullName ?? 'User Name',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
            SizedBox(height: 8.h),
            userState.maybeWhen(
              data: (user) => Text(
                user?.email ?? 'user@email.com',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
