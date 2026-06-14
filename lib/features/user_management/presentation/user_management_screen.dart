import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/config/capitalize.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/shared/widgets/custom_compact_tile.dart';
import 'package:hr_connect/features/shared/widgets/custom_confirm_dialog.dart';
import 'package:hr_connect/features/shared/widgets/custom_delete_dialog.dart';
import 'package:hr_connect/features/shared/widgets/custom_filter_section.dart';
import 'package:hr_connect/features/shared/widgets/custom_list_content.dart';
import 'package:hr_connect/features/shared/widgets/custom_search_appbar.dart';
import 'package:hr_connect/features/shared/widgets/error_card.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/providers/user_provider.dart';

enum StatusFilter { all, active, nonActive }

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Role? _selectedRole;
  StatusFilter _selectedStatus = StatusFilter.all;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).fetchUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> _getFilteredUsers(List<UserModel> users) {
    return users.where((user) {
      final matchesSearch =
          user.data.firstName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          user.data.lastName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          user.data.role.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesRole =
          _selectedRole == null ||
          user.data.role.name.toLowerCase() ==
              _selectedRole!.name.toLowerCase();

      final matchesStatus =
          _selectedStatus == StatusFilter.all ||
          (_selectedStatus == StatusFilter.active && user.isActive) ||
          (_selectedStatus == StatusFilter.nonActive && !user.isActive);

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
        _selectedRole = null;
        _selectedStatus = StatusFilter.all;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: CustomSearchAppBar(
        title: 'User Management',
        hintText: 'Search name or role...',
        isSearchActive: _isSearchActive,
        searchController: _searchController,
        searchQuery: _searchQuery,
        onSearchToggle: _toggleSearch,
        onSearchChanged: (value) => setState(() => _searchQuery = value),
        onSearchClear: () {
          _searchController.clear();
          setState(() => _searchQuery = '');
        },
      ),
      body: userState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorCard(error: error.toString()),
        data: (users) {
          final filteredUsers = _getFilteredUsers(users);
          final lastFetchTime = ref
              .read(userNotifierProvider.notifier)
              .lastFetchTime;

          return CustomListContent(
            items: filteredUsers,
            isLoading: userState.isLoading,
            lastFetchTime: lastFetchTime,
            emptyMessage: 'No users found matching your criteria.',
            onRefresh: () async {
              await ref.read(userNotifierProvider.notifier).refreshUsers();
            },
            filterSection: _isSearchActive
                ? CustomFilterRow(
                    filters: [
                      CustomFilterChip(
                        label: 'All Status',
                        selected: _selectedStatus == StatusFilter.all,
                        onSelected: (value) {
                          if (value) {
                            setState(() => _selectedStatus = StatusFilter.all);
                          }
                        },
                      ),
                      CustomFilterChip(
                        label: 'Active',
                        selected: _selectedStatus == StatusFilter.active,
                        onSelected: (value) {
                          if (value) {
                            setState(
                              () => _selectedStatus = StatusFilter.active,
                            );
                          }
                        },
                      ),
                      CustomFilterChip(
                        label: 'Non-Active',
                        selected: _selectedStatus == StatusFilter.nonActive,
                        onSelected: (value) {
                          if (value) {
                            setState(
                              () => _selectedStatus = StatusFilter.nonActive,
                            );
                          }
                        },
                      ),
                      const CustomFilterDivider(),
                      CustomFilterChip(
                        label: 'All Roles',
                        selected: _selectedRole == null,
                        onSelected: (value) {
                          if (value) setState(() => _selectedRole = null);
                        },
                      ),
                      ...Role.values.where((r) => r != Role.unknown).map((
                        role,
                      ) {
                        return CustomFilterChip(
                          label: Capitalize.firstLetterUppercase(role.name),
                          selected: _selectedRole == role,
                          onSelected: (value) {
                            setState(() => _selectedRole = value ? role : null);
                          },
                        );
                      }),
                    ],
                  )
                : null,
            itemBuilder: (user) {
              return Opacity(
                opacity: user.isActive ? 1.0 : 0.6,
                child: CustomCompactTile(
                  title: '${user.data.firstName} ${user.data.lastName}'.trim(),
                  subtitle: user.data.email,
                  fallbackText: user.data.firstName,
                  imageUrl: user.data.avatarUrl,
                  badgeText: Capitalize.firstLetterUppercase(
                    user.data.role.name,
                  ),
                  isTitleStrikeThrough: !user.isActive,
                  statusDotColor: user.isActive
                      ? colorScheme.primary
                      : colorScheme.error,
                  onTap: () => context.push('/edit-user', extra: user),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 22.sp,
                    ),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    onSelected: (value) {
                      if (value == 'toggleActive') {
                        final formattedName =
                            '${user.data.firstName} ${user.data.lastName.isNotEmpty ? '${user.data.lastName[0].toUpperCase()}.' : ''}'
                                .trim();
                        showCustomConfirmDialog(
                          context: context,
                          title: user.isActive
                              ? 'Deactivate User'
                              : 'Activate User',
                          description:
                              'Are you sure you want to change the status for $formattedName?',
                          confirmButtonText: 'Confirm',
                          isDestructive: user.isActive,
                          onConfirm: () {
                            if (user.isActive) {
                              ref
                                  .read(userNotifierProvider.notifier)
                                  .deactivateUser(user.id);
                            } else {
                              ref
                                  .read(userNotifierProvider.notifier)
                                  .activateUser(user.id);
                            }
                          },
                        );
                      }
                      if (value == 'delete') {
                        showCustomDeleteDialog(
                          context: context,
                          title: 'Delete User',
                          description:
                              'This action cannot be undone. This will permanently delete the user account and all associated data.',
                          expectedConfirmationText:
                              '${user.data.firstName} ${user.data.lastName}'
                                  .trim(),
                          onConfirm: () {
                            ref
                                .read(userNotifierProvider.notifier)
                                .deleteUser(user.id);
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'toggleActive',
                        child: Row(
                          children: [
                            Icon(
                              user.isActive
                                  ? Icons.block_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: user.isActive
                                  ? colorScheme.error
                                  : colorScheme.primary,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              user.isActive ? 'Deactivate' : 'Activate',
                              style: TextStyle(
                                color: user.isActive
                                    ? colorScheme.error
                                    : colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              color: colorScheme.error,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'user_management_fab',
        onPressed: () {
          context.push('/add-user');
        },
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
        child: Icon(Icons.add_rounded, size: 24.sp),
      ),
    );
  }
}
