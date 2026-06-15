import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/attendance/presentation/generate_qr_tab_view.dart';
import 'package:hr_connect/features/attendance/presentation/scan_qr_tab_view.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currenUser = ref.watch(authNotifierProvider).value;

    final isAuthorize =
        currenUser?.data.role == Role.admin ||
        currenUser?.data.role == Role.manager;

    if (isAuthorize) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Attendance',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            bottom: TabBar(
              indicatorColor: colorScheme.primary,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              indicatorWeight: 1.w,
              tabs: const [
                Tab(text: 'Scan QR'),
                Tab(text: 'Generate QR'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [ScanQrTabView(), GenerateQrTabView()],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: const ScanQrTabView(),
    );
  }
}
