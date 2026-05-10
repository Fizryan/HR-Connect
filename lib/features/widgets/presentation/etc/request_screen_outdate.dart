import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  RequestStatus? _selectedStatus;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaveNotifierProvider.notifier).fetchLeaveRequests();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LeaveRequestModel> _getFilteredLeaveRequests(
    List<LeaveRequestModel> leaveRequests,
  ) {
    return leaveRequests.where((leave) {
      final matchesSearch = leave.leaveType.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesStatus =
          _selectedStatus == null || leave.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
        _selectedStatus = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final leaveState = ref.watch(leaveNotifierProvider);

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
          actions: [
            IconButton(
              icon: Icon(
                _isSearchActive ? Icons.close_rounded : Icons.search_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: _toggleSearch,
              tooltip: 'Search & Filter',
            ),
          ],
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
          children: [
            leaveState.when(
              loading: () => leaveState.hasValue
                  ? _buildLeaveContent(
                      leaveState.value!,
                      colorScheme,
                      isLoading: true,
                    )
                  : const Center(child: CircularProgressIndicator()),
              error: (error, _) => leaveState.hasValue
                  ? _buildLeaveContent(
                      leaveState.value!,
                      colorScheme,
                      error: error.toString(),
                    )
                  : _buildErrorState(error.toString(), colorScheme),
              data: (leaveRequests) =>
                  _buildLeaveContent(leaveRequests, colorScheme),
            ),
            const Center(child: Text('Business Tab (Empty)')),
          ],
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

  Widget _buildErrorState(String message, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.sp,
              color: colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () {
                ref.read(leaveNotifierProvider.notifier).refreshLeaveRequests();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveContent(
    List<LeaveRequestModel> leaveRequests,
    ColorScheme colorScheme, {
    bool isLoading = false,
    String? error,
  }) {
    final filteredLeave = _getFilteredLeaveRequests(leaveRequests);
    final lastFetchTime = ref
        .read(leaveNotifierProvider.notifier)
        .lastFetchTime;

    return Column(
      children: [
        if (isLoading) const LinearProgressIndicator(),
        if (error != null)
          Container(
            color: colorScheme.errorContainer,
            padding: const EdgeInsets.all(8),
            child: Text(
              error,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: Stream.periodic(const Duration(minutes: 1)),
                builder: (context, _) {
                  final minutes = lastFetchTime != null
                      ? DateTime.now().difference(lastFetchTime).inMinutes
                      : null;
                  final timeString = minutes != null
                      ? (minutes == 0 ? 'Just now' : '$minutes minutes ago')
                      : 'Unknown';
                  return Text(
                    'Last updated: $timeString',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (_isSearchActive)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search leave type...',
                  hintStyle: WidgetStateProperty.all(
                    TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  ),
                  leading: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  trailing: _searchQuery.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                        ]
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
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
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedStatus = null);
                        },
                      ),
                    ),
                    ...RequestStatus.values.map((role) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(
                            Capitalize.firstLetterUppercase(role.name),
                          ),
                          selected: _selectedStatus == role,
                          showCheckmark: false,
                          selectedColor: colorScheme.primaryContainer,
                          onSelected: (value) {
                            setState(
                              () => _selectedStatus = value ? role : null,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        Expanded(
          child: filteredLeave.isEmpty
              ? Center(
                  child: Text(
                    'No leave requests found.',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15.sp,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => ref
                      .read(leaveNotifierProvider.notifier)
                      .refreshLeaveRequests(),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: colorScheme.primary,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: filteredLeave.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 76.w,
                      endIndent: 20.w,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) {
                      final leave = filteredLeave[index];
                      return _buildCompactRequestItem(
                        leaveType: leave.leaveType,
                        startDate: leave.startDate,
                        endDate: leave.endDate,
                        status: leave.status,
                        icon: Icons.calendar_today_rounded,
                        colorScheme: colorScheme,
                      );
                    },
                  ),
                ),
        ),
      ],
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
