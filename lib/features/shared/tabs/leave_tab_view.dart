import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/theme/status_color.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/leave/providers/leave_provider.dart';
import 'package:hr_connect/features/shared/widgets/custom_compact_tile.dart';
import 'package:hr_connect/features/shared/widgets/custom_filter_section.dart';
import 'package:hr_connect/features/shared/widgets/custom_list_content.dart';
import 'package:hr_connect/features/shared/widgets/error_card.dart';

class LeaveTabView extends ConsumerStatefulWidget {
  final String searchQuery;

  const LeaveTabView({super.key, required this.searchQuery});

  @override
  ConsumerState<LeaveTabView> createState() => _LeaveTabViewState();
}

class _LeaveTabViewState extends ConsumerState<LeaveTabView> {
  RequestStatus _selectedStatus = RequestStatus.all;

  List<LeaveModel> _getFilteredLeaves(List<LeaveModel> leaves) {
    return leaves.where((leave) {
      final matchesSearch =
          leave.data.description.toLowerCase().contains(
            widget.searchQuery.toLowerCase(),
          ) ||
          leave.data.type.toLowerCase().contains(
            widget.searchQuery.toLowerCase(),
          );
      final matchesStatus =
          _selectedStatus == RequestStatus.all ||
          leave.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final leaveState = ref.watch(leaveMeProvider);

    return leaveState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorCard(error: error.toString()),
      data: (leaves) {
        final filteredLeaves = _getFilteredLeaves(leaves);
        final lastFetchTime = DateTime.now();

        return CustomListContent(
          items: filteredLeaves,
          isLoading: leaveState.isLoading,
          lastFetchTime: lastFetchTime,
          emptyMessage: 'No leave requests found.',
          onRefresh: () async {
            await ref.read(leaveNotifierProvider.notifier).refreshLeaves();
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
          itemBuilder: (leave) {
            return CustomCompactTile(
              title: Capitalize.firstLetterUppercase(leave.data.type),
              subtitle: leave.data.description,
              fallbackText: 'L',
              badgeText: Capitalize.firstLetterUppercase(leave.status.name),
              statusDotColor: StatusColor.getStatusColor(
                colorScheme,
                leave.status,
              ),
              onTap: () => context.push(
                '/request-detail',
                extra: {
                  'id': leave.id,
                  'kind': RequestKind.leave,
                  'type': leave.data.type,
                  'description': leave.data.description,
                  'startDate': leave.data.startDate,
                  'endDate': leave.data.endDate,
                  'status': leave.status,
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
