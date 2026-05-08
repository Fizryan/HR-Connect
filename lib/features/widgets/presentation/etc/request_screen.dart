import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaveNotifierProvider.notifier).fetchLeaveRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            'Request Screen',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 8.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: colorScheme.onPrimary,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Leave'),
                    Tab(text: 'Business'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const ClampingScrollPhysics(),
          children: [_buildLeaveTabContent(colorScheme), const Scaffold()],
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {},
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          elevation: 0,
          child: Icon(Icons.add_rounded, size: 24.sp),
        ),
      ),
    );
  }

  Widget _buildLeaveTabContent(ColorScheme colorScheme) {
    // TODO: Implement leave tab content here
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      physics: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
      itemCount: 5,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 20.w,
        endIndent: 20.w,
        color: colorScheme.outlineVariant..withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        return _buildCompactRequestItem(
          leaveType: LeaveType.casual,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 2)),
          status: RequestStatus.pending,
          icon: Icons.calendar_today_rounded,
          colorScheme: colorScheme,
        );
      },
    );
  }

  Widget _buildCompactRequestItem({
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required RequestStatus status,
    String? description,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
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

    return Material(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24.sp, color: colorScheme.primary),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leave ${Capitalize.firstLetterUppercase(leaveType.name)}',
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
                          Icons.calendar_today_rounded,
                          size: 12.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          description ?? 'N/A',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
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
                  status.name,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
