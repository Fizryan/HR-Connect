import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/constants/assets.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authNotifierProvider);

    final statusText = authState.when(
      data: (user) => user == null ? 'Preparing Workspace...' : 'Welcome Back!',
      loading: () => 'Authenticating Credentials...',
      error: (_, _) => 'Error during setup',
    );

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.7 + (0.3 * value),
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    Assets.logoRounded,
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.business_center_rounded,
                          size: 60.sp,
                          color: colorScheme.surface,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'HR Connect',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: Text(
                      statusText,
                      key: ValueKey<String>(statusText),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 200.w,
                    height: 4.h,
                    child: LinearProgressIndicator(
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FutureBuilder<PackageInfo>(
                    future: _packageInfoFuture,
                    builder: (context, snapshot) {
                      final versionStr = snapshot.hasData
                          ? snapshot.data!.version
                          : '...';
                      return Text(
                        'v$versionStr',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: colorScheme.outline,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
