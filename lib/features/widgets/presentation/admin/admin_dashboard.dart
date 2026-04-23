import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_provider.dart';
import 'package:hr_connect/features/widgets/model/list_menu.dart';
import 'package:hr_connect/features/widgets/model/list_overview.dart';
import 'package:hr_connect/features/widgets/shared_widgets.dart';

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
      title: 'Overtime',
      icon: Icons.more_time_outlined,
      iconColor: widget.colorScheme.primary,
      onTap: () {
        // TODO: Navigate to the overtime screen
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

  late List<ListOverview> listOverview = [
    ListOverview(
      title: 'Total Users',
      subtitle: '0', // TODO: Replace with actual value
      icon: Icons.people_outline_outlined,
      iconColor: widget.colorScheme.primary,
    ),
    ListOverview(
      title: 'Total Account',
      subtitle: '0', // TODO: Replace with actual value
      icon: Icons.account_circle_outlined,
      iconColor: widget.colorScheme.primary,
    ),
    ListOverview(
      title: 'Total Leave Requst',
      subtitle: '0', // TODO: Replace with actual value
      icon: Icons.home_work_outlined,
      iconColor: widget.colorScheme.primary,
    ),
    ListOverview(
      title: 'Total Business Trip',
      subtitle: '0', // TODO: Replace with actual value
      icon: Icons.travel_explore_outlined,
      iconColor: widget.colorScheme.primary,
    ),
    ListOverview(
      title: 'Total Overtime',
      subtitle: '0', // TODO: Replace with actual value
      icon: Icons.more_time_outlined,
      iconColor: widget.colorScheme.primary,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Admin ✌️😉', // TODO: Replace with user's name
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 16.h),
          MenuWidgets(
            colorScheme: widget.colorScheme,
            title: 'Menus',
            menus: menu,
            icon: Icons.view_module_rounded,
          ),
          SizedBox(height: 16.h),
          OverviewWidgets(
            colorScheme: widget.colorScheme,
            title: 'Activity',
            listOverview: listOverview,
          ),
        ],
      ),
    );
  }
}
