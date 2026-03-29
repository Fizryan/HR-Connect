import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hr_connect/core/theme/app_colors.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_provider.dart';
import 'package:hr_connect/features/user_management/presentation/providers/user_state.dart';
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

  bool get isDark => widget.colorScheme.brightness == Brightness.dark;

  Color _themedColor(Color light, Color dark) => isDark ? dark : light;

  // TODO: OnTap action menu
  List<ListMenu> get _actionMenu => [
    ListMenu(
      title: 'User',
      icon: Icons.mode_edit_outline_outlined,
      iconColor: _themedColor(AppColors.accent, Colors.blue.shade300),
      isNew: true,
    ),
    ListMenu(
      title: 'Leave',
      icon: Icons.calendar_month_outlined,
      iconColor: _themedColor(AppColors.warning, Colors.orange.shade300),
    ),
    ListMenu(
      title: 'Medical',
      icon: Icons.medical_services_outlined,
      iconColor: _themedColor(AppColors.error, Colors.red.shade400),
    ),
    ListMenu(
      title: 'Overtime',
      icon: Icons.more_time_outlined,
      iconColor: _themedColor(Colors.purple.shade600, Colors.purple.shade300),
    ),
    ListMenu(
      title: 'Personal Info',
      icon: Icons.person_2_outlined,
      iconColor: _themedColor(AppColors.success, Colors.teal.shade300),
    ),
    ListMenu(
      title: 'Report',
      icon: Icons.assignment_turned_in_outlined,
      iconColor: _themedColor(Colors.indigo.shade600, Colors.indigo.shade300),
    ),
    ListMenu(
      title: 'Rules',
      icon: Icons.rule,
      iconColor: _themedColor(Colors.brown.shade600, Colors.brown.shade300),
    ),
    ListMenu(
      title: 'Help',
      icon: Icons.help_center_outlined,
      iconColor: _themedColor(Colors.green.shade700, Colors.green.shade400),
    ),
  ];

  List<ListOverview> _getOverviewMenu(String userCount, String activeCount, String inactiveCount) => [
    ListOverview(
      title: 'Total Users',
      subtitle: userCount,
      icon: Icons.people_alt_outlined,
      iconColor: _themedColor(AppColors.accent, Colors.blue.shade300),
    ),
    ListOverview(
      title: 'Active Users',
      subtitle: activeCount,
      icon: Icons.person_3_outlined,
      iconColor: _themedColor(AppColors.success, Colors.green.shade300),
    ),
    ListOverview(
      title: 'Inactive Users',
      subtitle: inactiveCount,
      icon: Icons.person_off_outlined,
      iconColor: _themedColor(AppColors.error, Colors.red.shade300),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InformationWidgets(
            colorScheme: widget.colorScheme,
            desciption: 'Under Development',
            icon: Icons.construction_outlined,
            iconColor: _themedColor(AppColors.warning, Colors.orange.shade300),
          ),
          SizedBox(height: 16.h),
          MenuWidgets(
            colorScheme: widget.colorScheme,
            title: 'Action Menu',
            menus: _actionMenu,
            icon: Icons.admin_panel_settings_outlined,
          ),
          SizedBox(height: 16.h),
          ValueListenableBuilder<UserState>(
            valueListenable: _userProvider,
            builder: (context, state, child) {
              String userCount = '...';
              String activeCount = '...';
              String inactiveCount = '...';
              state.maybeWhen(
                dataList: (users) {
                  userCount = users.length.toString();
                  activeCount = users.where((u) => u.isActive).length.toString();
                  inactiveCount = users.where((u) => !u.isActive).length.toString();
                },
                error: (_) {
                  userCount = 'Error';
                  activeCount = 'Error';
                  inactiveCount = 'Error';
                },
                orElse: () {
                  userCount = '...';
                  activeCount = '...';
                  inactiveCount = '...';
                },
              );
              
              return OverviewWidgets(
                colorScheme: widget.colorScheme,
                title: 'Overview',
                listOverview: _getOverviewMenu(userCount, activeCount, inactiveCount),
              );
            },
          ),
        ],
      ),
    );
  }
}
