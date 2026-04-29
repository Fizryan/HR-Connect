import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/features/logic/user_management/providers/user_provider.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';

class AdminDashboard extends StatefulWidget {
  final ColorScheme colorScheme;

  const AdminDashboard({super.key, required this.colorScheme});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late final UserProvider _userProvider;
  late List<ListMenu> menu = [
    ListMenu(
      title: 'Attendance',
      icon: Icons.input_outlined,
      iconColor: widget.colorScheme.primary,
      onTap: () {
        // TODO: Navigate to the attendance screen
      },
    ),
    ListMenu(
      title: 'Leave',
      icon: Icons.home_work_outlined,
      iconColor: widget.colorScheme.primary,
      onTap: () {
        // TODO: Navigate to the leave screen
      },
    ),
    ListMenu(
      title: 'Business Trip',
      icon: Icons.travel_explore_outlined,
      iconColor: widget.colorScheme.primary,
      onTap: () {
        // TODO: Navigate to the business trip screen
      },
    ),
    ListMenu(
      title: 'Users',
      icon: Icons.people_outline_outlined,
      iconColor: widget.colorScheme.primary,
      onTap: () {
        // TODO: Navigate to the users screen
      },
    ),
    ListMenu(
      title: 'Account',
      icon: Icons.account_circle_outlined,
      iconColor: widget.colorScheme.primary,
      onTap: () {
        // TODO: Navigate to the account screen
      },
    ),
  ];

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Under Development'),
        ],
      ),
    );
  }
}
