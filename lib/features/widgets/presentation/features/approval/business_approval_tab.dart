import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/business_trip/data/model/business_trip_model.dart';
import 'package:hr_connect/features/business_trip/provider/business_provider.dart';
import 'package:hr_connect/features/widgets/shared/shared_request_card.dart';

class BusinessApprovalTab extends ConsumerStatefulWidget {
  const BusinessApprovalTab({super.key});

  @override
  ConsumerState<BusinessApprovalTab> createState() =>
      _BusinessApprovalTabState();
}

class _BusinessApprovalTabState extends ConsumerState<BusinessApprovalTab> {
  RequestStatus? _selectedStatus = RequestStatus.pending;
  bool _isSearchActive = false;

  late final Stream<void> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(const Duration(minutes: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessNotifierProvider.notifier).fetchBusinessTrip();
    });
  }

  List<BusinessTripModel> _getFilteredRequests(
    List<BusinessTripModel> requests,
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
    final businessState = ref.watch(businessNotifierProvider);

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
          child: businessState.when(
            loading: () => businessState.hasValue
                ? _buildBusinessList(
                    businessState.value!,
                    colorScheme,
                    isLoading: true,
                  )
                : const Center(child: CircularProgressIndicator()),
            error: (error, _) => businessState.hasValue
                ? _buildBusinessList(
                    businessState.value!,
                    colorScheme,
                    error: error.toString(),
                  )
                : _buildErrorState(error.toString(), colorScheme),
            data: (businessTrip) =>
                _buildBusinessList(businessTrip, colorScheme),
          ),
        ),
      ],
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
              onPressed: () => ref
                  .read(businessNotifierProvider.notifier)
                  .refreshBusinessTrip(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessList(
    List<BusinessTripModel> businessTrip,
    ColorScheme colorScheme, {
    bool isLoading = false,
    String? error,
  }) {
    final filteredTrip = _getFilteredRequests(businessTrip);
    final lastFetchTime = ref
        .read(businessNotifierProvider.notifier)
        .lastFetchTime;

    return Column(
      children: [
        if (isLoading) const LinearProgressIndicator(),
        if (error != null)
          Container(
            width: double.infinity,
            color: colorScheme.errorContainer,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
            child: Text(
              error,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                stream: _timeStream,
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
        Expanded(
          child: filteredTrip.isEmpty
              ? Center(
                  child: Text(
                    'No business trip found.',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15.sp,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => ref
                      .read(businessNotifierProvider.notifier)
                      .refreshBusinessTrip(),
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: colorScheme.primary,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 8.h, 0, 80.h),
                    itemCount: filteredTrip.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 76.w,
                      endIndent: 20.w,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) {
                      final trip = filteredTrip[index];
                      return SharedRequestCard(
                        title: 'Business Trip - ${Capitalize.firstLetterUppercase(trip.businessTripType.name)}',
                        startDate: trip.startDate,
                        endDate: trip.endDate,
                        status: trip.status,
                        icon: Icons.work_rounded,
                        colorScheme: colorScheme,
                        onApprove: () => ref
                            .read(businessNotifierProvider.notifier)
                            .approveBusinessTrip(trip.id),
                        onReject: () => ref
                            .read(businessNotifierProvider.notifier)
                            .rejectBusinessTrip(trip.id),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
