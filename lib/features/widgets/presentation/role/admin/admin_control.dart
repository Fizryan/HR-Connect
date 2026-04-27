import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_provider.dart';
import 'package:hr_connect/features/widgets/presentation/role/admin/admin_users_tabs.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<_AdminTabItem> tabs = [
      _AdminTabItem(
        title: 'Users',
        content: AdminUsersTab(
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
          backgroundColor: colorScheme.surfaceContainerHighest,
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
          elevation: 0,
          title: TabBar(
            indicatorColor: colorScheme.onSurface,
            labelColor: colorScheme.onSurface,
            unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
            indicatorWeight: 3.h,
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            tabs: tabs.map((tab) => Tab(text: tab.title)).toList(),
          ),
        ),
        body: TabBarView(children: tabs.map((tab) => tab.content).toList()),
      ),
    );
  }
}
