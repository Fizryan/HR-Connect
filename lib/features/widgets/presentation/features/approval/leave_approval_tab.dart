import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';

class LeaveApprovalTab extends ConsumerStatefulWidget {
  const LeaveApprovalTab({super.key});

  @override
  ConsumerState<LeaveApprovalTab> createState() => _LeaveApprovalTabState();
}

class _LeaveApprovalTabState extends ConsumerState<LeaveApprovalTab> {
  RequestStatus? _selectedStatus = RequestStatus.pending;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaveNotifierProvider.notifier).fetchLeaveRequests();
    });
  }

  List<LeaveRequestModel> _getFilteredRequests(
    List<LeaveRequestModel> requests,
  ) {
    return requests.where((req) {
      final matchesStatus =
          _selectedStatus == null || req.status == _selectedStatus;
      return matchesStatus;
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _selectedStatus = RequestStatus.pending;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final leaveState = ref.watch(leaveNotifierProvider);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Awaiting Your Action',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isSearchActive
                      ? Icons.close_rounded
                      : Icons.filter_list_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: _toggleSearch,
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),

        if (_isSearchActive) ...[
          SizedBox(
            height: 40.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ChoiceChip(
                    label: const Text('All Status'),
                    selected: _selectedStatus == null,
                    showCheckmark: false,
                    selectedColor: colorScheme.primaryContainer,
                    onSelected: (s) => setState(() => _selectedStatus = null),
                  ),
                ),
                ...RequestStatus.values.map((status) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(Capitalize.firstLetterUppercase(status.name)),
                      selected: _selectedStatus == status,
                      showCheckmark: false,
                      selectedColor: colorScheme.primaryContainer,
                      onSelected: (s) =>
                          setState(() => _selectedStatus = s ? status : null),
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],

        Expanded(
          child: leaveState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Text(
                err.toString(),
                style: TextStyle(color: colorScheme.error),
              ),
            ),
            data: (requests) {
              final filteredRequests = _getFilteredRequests(requests);
              if (filteredRequests.isEmpty) {
                return Center(
                  child: Text(
                    'No requests found.',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15.sp,
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async => ref
                    .read(leaveNotifierProvider.notifier)
                    .refreshLeaveRequests(),
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: colorScheme.primary,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 20.w,
                  ),
                  itemCount: filteredRequests.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return _buildActionCard(
                      filteredRequests[index],
                      colorScheme,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(LeaveRequestModel req, ColorScheme colorScheme) {
    final isPending = req.status == RequestStatus.pending;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: colorScheme.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      req.requestId,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Leave ${Capitalize.firstLetterUppercase(req.leaveType.name)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isPending) _buildStatusBadge(req.status, colorScheme),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 16.sp,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 8.w),
              Text(
                '${req.startDate.day}/${req.startDate.month}/${req.startDate.year} - ${req.endDate.day}/${req.endDate.month}/${req.endDate.year}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          if (isPending) ...[
            SizedBox(height: 16.h),
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ref
                        .read(leaveNotifierProvider.notifier)
                        .rejectLeaveRequest(req.id),
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
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => ref
                        .read(leaveNotifierProvider.notifier)
                        .approveLeaveRequest(req.id),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.check_rounded, size: 18.sp),
                    label: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(RequestStatus status, ColorScheme colorScheme) {
    final isApproved = status == RequestStatus.approved;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.withValues(alpha: 0.15)
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        Capitalize.firstLetterUppercase(status.name),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: isApproved ? Colors.green.shade700 : colorScheme.error,
        ),
      ),
    );
  }
}
