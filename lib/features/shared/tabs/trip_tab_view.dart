import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/theme/status_color.dart';
import 'package:hr_connect/features/shared/widgets/custom_compact_tile.dart';
import 'package:hr_connect/features/shared/widgets/custom_filter_section.dart';
import 'package:hr_connect/features/shared/widgets/custom_list_content.dart';
import 'package:hr_connect/features/shared/widgets/error_card.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';
import 'package:hr_connect/features/trip/provider/trip_provider.dart';

class TripTabView extends ConsumerStatefulWidget {
  final String searchQuery;

  const TripTabView({super.key, required this.searchQuery});

  @override
  ConsumerState<TripTabView> createState() => _TripTabViewState();
}

class _TripTabViewState extends ConsumerState<TripTabView> {
  RequestStatus _selectedStatus = RequestStatus.all;

  List<TripModel> _getFilteredTrips(List<TripModel> trips) {
    return trips.where((trip) {
      final matchesSearch =
          trip.data.description.toLowerCase().contains(
            widget.searchQuery.toLowerCase(),
          ) ||
          trip.data.type.toLowerCase().contains(
            widget.searchQuery.toLowerCase(),
          );

      final matchesStatus =
          _selectedStatus == RequestStatus.all ||
          trip.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final tripState = ref.watch(tripMeProvider);

    return tripState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorCard(error: error.toString()),
      data: (trips) {
        final filteredTrips = _getFilteredTrips(trips);

        final lastFetchTime = DateTime.now();

        return CustomListContent(
          items: filteredTrips,
          isLoading: tripState.isLoading,
          lastFetchTime: lastFetchTime,
          emptyMessage: 'No trip requests found.',
          onRefresh: () async {
            await ref.read(tripNotifierProvider.notifier).refreshTrips();
          },
          filterSection: CustomFilterRow(
            filters: [
              CustomFilterChip(
                label: 'All',
                selected: _selectedStatus == RequestStatus.all,
                onSelected: (val) {
                  if (val) setState(() => _selectedStatus = RequestStatus.all);
                },
              ),
              CustomFilterChip(
                label: 'Pending',
                selected: _selectedStatus == RequestStatus.pending,
                onSelected: (val) {
                  if (val) {
                    setState(() => _selectedStatus = RequestStatus.pending);
                  }
                },
              ),
              CustomFilterChip(
                label: 'Approved',
                selected: _selectedStatus == RequestStatus.approved,
                onSelected: (val) {
                  if (val) {
                    setState(() => _selectedStatus = RequestStatus.approved);
                  }
                },
              ),
              CustomFilterChip(
                label: 'Rejected',
                selected: _selectedStatus == RequestStatus.rejected,
                onSelected: (val) {
                  if (val) {
                    setState(() => _selectedStatus = RequestStatus.rejected);
                  }
                },
              ),
            ],
          ),
          itemBuilder: (trip) {
            return CustomCompactTile(
              title: Capitalize.firstLetterUppercase(trip.data.type),
              subtitle: trip.data.description,
              fallbackText: 'T',
              badgeText: Capitalize.firstLetterUppercase(trip.status.name),
              statusDotColor: StatusColor.getStatusColor(
                colorScheme,
                trip.status,
              ),
              onTap: () => context.push(
                '/request-detail',
                extra: {
                  'id': trip.id,
                  'kind': RequestKind.trip,
                  'type': trip.data.type,
                  'description': trip.data.description,
                  'startDate': trip.data.startDate,
                  'endDate': trip.data.endDate,
                  'status': trip.status,
                },
              ),
              trailing: const Icon(Icons.chevron_right_outlined),
            );
          },
        );
      },
    );
  }
}
