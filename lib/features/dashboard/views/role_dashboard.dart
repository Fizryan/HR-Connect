import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/dashboard/controllers/dashboard_controller.dart';
import 'package:hr_connect/features/dashboard/models/dashboard_data.dart';
import 'package:hr_connect/features/dashboard/widgets/dashboard_content.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class RoleDashboard extends StatefulWidget {
  final UserModel user;

  const RoleDashboard({super.key, required this.user});

  @override
  State<RoleDashboard> createState() => _RoleDashboardState();
}

class _RoleDashboardState extends State<RoleDashboard> {
  late Future<DashboardData> _dashboardDataFuture;

  @override
  void initState() {
    super.initState();
    _loadData(forceRefresh: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AttendanceController>().fetchTodayAttendance(
          widget.user.uid,
        );
      }
    });
  }

  void _loadData({required bool forceRefresh}) {
    final controller = context.read<DashboardController>();
    _dashboardDataFuture = controller.fetchDashboardData(
      forceRefresh: forceRefresh,
    );
  }

  Future<void> _refreshData() async {
    final attendanceController = context.read<AttendanceController>();
    await attendanceController.fetchTodayAttendance(widget.user.uid);
    setState(() {
      _loadData(forceRefresh: true);
    });
    await _dashboardDataFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<DashboardController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              if (controller.isOffline)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  color: Colors.orange.shade700,
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'You\'re offline. Showing cached data.',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        TextButton(
                          onPressed: _refreshData,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: FutureBuilder<DashboardData>(
                  future: _dashboardDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError && controller.cachedData == null) {
                      return EmptyState(
                        icon: Icons.error_outline,
                        title: 'Error loading data',
                        subtitle: 'Please check your connection and try again.',
                        action: ElevatedButton.icon(
                          onPressed: _refreshData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting &&
                        controller.cachedData == null) {
                      return const LoadingState(
                        message: 'Loading dashboard...',
                      );
                    }

                    final data = snapshot.data ?? controller.cachedData;
                    if (data == null) {
                      return EmptyState(
                        icon: Icons.inbox_outlined,
                        title: 'No data available',
                        action: ElevatedButton(
                          onPressed: _refreshData,
                          child: const Text('Refresh'),
                        ),
                      );
                    }

                    return DashboardContent(
                      user: widget.user,
                      data: data,
                      onRefresh: _refreshData,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
