import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:hr_connect/features/user_management/data/models/user_model.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_provider.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_state.dart';
import 'package:hr_connect/features/widgets/presentation/admin/admin_user_card.dart';

class AdminControl extends StatefulWidget {
  final ColorScheme colorScheme;

  const AdminControl({super.key, required this.colorScheme});

  @override
  State<AdminControl> createState() => _AdminControlState();
}

class _AdminTabItem {
  final String title;
  final Widget content;

  _AdminTabItem({required this.title, required this.content});
}

class _AdminControlState extends State<AdminControl> {
  late final UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = GetIt.I<UserProvider>();
    _userProvider.fetchAllUsers();
  }

  @override
  void dispose() {
    _userProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final List<_AdminTabItem> tabs = [
      _AdminTabItem(
        title: 'Users',
        content: _AdminUsersTab(
          colorScheme: colorScheme,
          userProvider: _userProvider,
        ),
      ),
      _AdminTabItem(
        title: 'Account',
        content: const Center(child: Text('Account Management (Coming Soon)')),
      ),
    ];

    if (tabs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          title: Text(
            'Admin Control',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        body: const Center(child: Text('No modules available.')),
      );
    }
    
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          title: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface,
            indicatorWeight: 3.h,
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            tabs: tabs.map((tab) => Tab(text: tab.title)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((tab) => tab.content).toList(),
        ),
      ),
    );
  }
}

class _AdminUsersTab extends StatefulWidget {
  final ColorScheme colorScheme;
  final UserProvider userProvider;

  const _AdminUsersTab({
    required this.colorScheme,
    required this.userProvider,
  });

  @override
  State<_AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<_AdminUsersTab> {
  String _searchQuery = '';
  UserRole? _selectedRole;

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
                setState(() => _searchQuery = value.toLowerCase());
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
                DropdownItem<UserRole?>(
                  value: null, 
                  child: Text('All Roles'),
                ),
                ...UserRole.values.map(
                  (role) => DropdownItem<UserRole?>(
                    value: role,
                    child: Text(role.name.toUpperCase()),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedRole = value);
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
      final nameMatches = '${user.firstName} ${user.lastName}'.toLowerCase().contains(_searchQuery);
      final roleMatches = _selectedRole == null || user.role == _selectedRole;
      return nameMatches && roleMatches;
    }).toList();

    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        childAspectRatio: 1, 
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.w,
      ),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        return AdminUserCard(
          user: filteredUsers[index],
          colorScheme: colorScheme,
          onTap: () {
            // TODO: Route to actual edit user page instead of this placeholder
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Edit User')),
                  body: Center(
                    child: Text('Edit User: ${filteredUsers[index].firstName}'),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
