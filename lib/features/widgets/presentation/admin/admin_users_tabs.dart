import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_provider.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_state.dart';
import 'package:hr_connect/features/widgets/presentation/admin/admin_user_card.dart';

class AdminUsersTab extends StatefulWidget {
  final ColorScheme colorScheme;
  final UserProvider userProvider;

  const AdminUsersTab({super.key, required this.colorScheme, required this.userProvider});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  String _searchQuery = '';
  UserRole? _selectedRole;
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterSection(widget.colorScheme),
        Expanded(
          child: ValueListenableBuilder<UserState>(
            valueListenable: widget.userProvider,
            builder: (context, state, child) {
              return state.maybeWhen(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (message) => Center(child: Text('Error: $message')),
                dataList: (users) => _buildGrid(users, widget.colorScheme),
                orElse: () => const Center(child: Text('No Data Available')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                  _currentPage = 1;
                });
              },
            ),
          ),
          SizedBox(width: 8.w),
          DropdownButtonHideUnderline(
            child: DropdownButton2<UserRole?>(
              customButton: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(12.r),
                  color: _selectedRole != null
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                ),
                child: Icon(
                  Icons.filter_list,
                  color: _selectedRole != null
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              items: [
                DropdownItem<UserRole?>(value: null, child: Text('All Roles')),
                ...UserRole.values.map(
                  (role) => DropdownItem<UserRole?>(
                    value: role,
                    child: Text(role.name.toUpperCase()),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                  _currentPage = 1;
                });
              },
              dropdownStyleData: DropdownStyleData(
                width: 160.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                offset: const Offset(0, -8),
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<UserModel> users, ColorScheme colorScheme) {
    final filteredUsers = users.where((user) {
      final nameMatches = '${user.firstName} ${user.lastName}'
          .toLowerCase()
          .contains(_searchQuery);
      final roleMatches = _selectedRole == null || user.role == _selectedRole;
      return nameMatches && roleMatches;
    }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    final totalPages = (filteredUsers.length / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(
      0,
      filteredUsers.length,
    );
    final paginatedUsers = filteredUsers.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.w,
            ),
            itemCount: paginatedUsers.length,
            itemBuilder: (context, index) {
              return AdminUserCard(
                user: paginatedUsers[index],
                colorScheme: colorScheme,
                onTap: () {
                  // TODO: Route to actual edit user page instead of this placeholder
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: const Text('Edit User')),
                        body: Center(
                          child: Text(
                            'Edit User: ${paginatedUsers[index].firstName}',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (totalPages > 1) _buildPaginationControls(totalPages, colorScheme),
      ],
    );
  }

  Widget _buildPaginationControls(int totalPages, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
          color: colorScheme.primary,
        ),
        SizedBox(width: 4.w),
        Text(
          '$_currentPage of $totalPages',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 4.w),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages
              ? () => setState(() => _currentPage++)
              : null,
          color: colorScheme.primary,
        ),
      ],
    );
  }
}