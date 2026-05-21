import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/capitalize.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/business_trip/data/model/business_trip_model.dart';
import 'package:hr_connect/features/business_trip/provider/business_provider.dart';
import 'package:hr_connect/features/widgets/presentation/features/approval/request_detail_screen.dart';
import 'package:hr_connect/features/widgets/shared/shared_request_card.dart';
class BusinessTripTab extends ConsumerStatefulWidget {
  const BusinessTripTab({super.key});

  @override
  ConsumerState<BusinessTripTab> createState() => _BusinessTripTabState();
}

class _BusinessTripTabState extends ConsumerState<BusinessTripTab> {
  final TextEditingController _searchController = TextEditingController();
  RequestStatus? _selectedStatus;
  bool _isSearchActive = false;
  late final Stream<void> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(const Duration(minutes: 1));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BusinessTripModel> _getFilteredBusinessTrip(
    List<BusinessTripModel> businessTrip,
  ) {
    return businessTrip.where((trip) {
      final matchedStatus =
          _selectedStatus == null || trip.status == _selectedStatus;
      return matchedStatus;
    }).toList();
  }

  void _toggleFilter() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _selectedStatus = null;
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
                'Business Trip',
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
                ),
                onPressed: _toggleFilter,
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
                ...RequestStatus.values.map((status) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(Capitalize.firstLetterUppercase(status.name)),
                      selected: _selectedStatus == status,
                      showCheckmark: false,
                      selectedColor: colorScheme.primaryContainer,
                      onSelected: (selected) {
                        setState(
                          () => _selectedStatus = selected ? status : null,
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
    final filteredBusinessTrip = _getFilteredBusinessTrip(businessTrip);
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
          child: filteredBusinessTrip.isEmpty
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
                    itemCount: filteredBusinessTrip.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 76.w,
                      endIndent: 20.w,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) {
                      final trip = filteredBusinessTrip[index];
                      return SharedRequestCard(
                        title: 'Business Trip - ${Capitalize.firstLetterUppercase(trip.businessTripType.name)}',
                        startDate: trip.startDate,
                        endDate: trip.endDate,
                        status: trip.status,
                        icon: Icons.calendar_today_rounded,
                        colorScheme: colorScheme,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestDetailScreen(
                                title: 'Business Trip - ${Capitalize.firstLetterUppercase(trip.businessTripType.name)}',
                                description: trip.description ?? 'No description provided.',
                                startDate: trip.startDate,
                                endDate: trip.endDate,
                                status: trip.status,
                                icon: Icons.calendar_today_rounded,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

}
