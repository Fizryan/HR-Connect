import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/features/dashboard/providers/dashboard_providers.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';
import 'package:hr_connect/features/shared/widgets/error_card.dart';
import 'package:hr_connect/features/shared/widgets/metrics_grid.dart';
import 'package:hr_connect/features/shared/widgets/profile_card.dart';
import 'package:hr_connect/features/shared/widgets/recent_list.dart';
import 'package:hr_connect/features/shared/widgets/section_header.dart';
import 'package:hr_connect/features/shared/widgets/status_card.dart';
import 'package:hr_connect/features/trip/provider/trip_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final leaveState = ref.watch(leaveMeProvider);
    final tripState = ref.watch(tripMeProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dashboardNotifierProvider);
        ref.invalidate(leaveMeProvider);
        ref.invalidate(tripMeProvider);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(),
            SizedBox(height: 24.h),
            dashboardState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorCard(error: err.toString()),
              data: (dashboard) => MetricsGrid(dashboard: dashboard),
            ),
            SizedBox(height: 32.h),
            SectionHeader(
              title: 'Recent Leave Requests',
              showSeeAll: leaveState.hasValue && leaveState.value!.isNotEmpty,
              onSeeAll: () {
                context.push('/leave');
              },
            ),
            leaveState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorCard(error: err.toString()),
              data: (leaves) => RecentList(
                items: leaves,
                emptyMesage: 'No recent leave requests',
                emptyIcon: Icons.inbox_outlined,
                itemBuilder: (leave) => StatusCard(
                  title: Capitalize.firstLetterUppercase(leave.data.type),
                  description: leave.data.description,
                  subtitle:
                      '${leave.data.startDate.day}/${leave.data.startDate.month}/${leave.data.startDate.year} - ${leave.data.endDate.day}/${leave.data.endDate.month}/${leave.data.endDate.year}',
                  icon: Icons.beach_access_outlined,
                  status: leave.status.name,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SectionHeader(
              title: 'Recent Trip Requests',
              showSeeAll: tripState.hasValue && tripState.value!.isNotEmpty,
              onSeeAll: () {
                context.push('/trip');
              },
            ),
            tripState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorCard(error: err.toString()),
              data: (trips) => RecentList(
                items: trips,
                emptyMesage: 'No recent trip requests',
                emptyIcon: Icons.hourglass_empty_outlined,
                itemBuilder: (trip) => StatusCard(
                  title: Capitalize.firstLetterUppercase(trip.data.type),
                  description: trip.data.description,
                  subtitle:
                      '${trip.data.startDate.day}/${trip.data.startDate.month}/${trip.data.startDate.year} - ${trip.data.endDate.day}/${trip.data.endDate.month}/${trip.data.endDate.year}',
                  icon: Icons.business_center_outlined,
                  status: trip.status.name,
                ),
              ),
            ),
            SizedBox(height: 42.h),
          ],
        ),
      ),
    );
  }
}
