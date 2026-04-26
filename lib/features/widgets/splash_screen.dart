import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSplash();
    });
  }

  Future<void> _initializeSplash() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      context.read<AuthProvider>().checkAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                    'assets/logo_icon.png',
                    width: 110.w,
                    height: 110.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.business_center_rounded,
                        size: 110.sp,
                        color: colorScheme.onSurface,
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
                      fontSize: 28.sp,
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
                  SizedBox(
                    width: 300.w,
                    height: 4.w,
                    child: LinearProgressIndicator(
                      color: colorScheme.primary.withValues(alpha: 0.6),
                      backgroundColor: colorScheme.onSurface.withValues(
                        alpha: 0.1,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FutureBuilder<PackageInfo>(
                    future: _packageInfoFuture,
                    builder: (context, snapshot) {
                      final versionStr = snapshot.hasData
                          ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                          : 'Loading...';
                      return Text(
                        'v$versionStr',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
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
