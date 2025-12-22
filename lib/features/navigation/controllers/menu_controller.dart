import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/dashboard/views/role_dashboard.dart';
import 'package:hr_connect/features/dashboard/panel/employee/employee_dashboard.dart';
import 'package:hr_connect/features/dashboard/panel/supervisor/supervisor_dashboard.dart';
import 'package:hr_connect/features/dashboard/panel/finance/finance_dashboard.dart';
import 'package:hr_connect/features/navigation/models/menu_model.dart';
import 'package:hr_connect/features/settings/views/settings_view.dart';
import 'package:hr_connect/features/user_management/views/user_management_view.dart';
import 'package:hr_connect/features/user_management/views/hrd_user_management_view.dart';
import 'package:hr_connect/features/attendance/views/attendance_view.dart';
import 'package:hr_connect/features/leave/views/leave_management_view.dart';
import 'package:hr_connect/features/leave/views/leave_request_view.dart';
import 'package:hr_connect/features/reports/views/reports_view.dart';
import 'package:hr_connect/features/reimbursement/views/reimbursement_request_view.dart';
import 'package:hr_connect/features/reimbursement/views/reimbursement_management_view.dart';

class MenuConfig {
  static MenuNavigation _adminDashboard(UserModel user) => MenuNavigation(
    label: 'Dashboard',
    iconData: Icons.dashboard_rounded,
    page: RoleDashboard(user: user),
  );

  static MenuNavigation _hrdDashboard(UserModel user) => MenuNavigation(
    label: 'Dashboard',
    iconData: Icons.badge_rounded,
    page: RoleDashboard(user: user),
  );

  static MenuNavigation _supervisorDashboard(UserModel user) => MenuNavigation(
    label: 'Team',
    iconData: Icons.supervisor_account_rounded,
    page: SupervisorDashboard(user: user),
  );

  static MenuNavigation _financeDashboard(UserModel user) => MenuNavigation(
    label: 'Finance',
    iconData: Icons.account_balance_wallet_rounded,
    page: FinanceDashboard(user: user),
  );

  static MenuNavigation _employeeDashboard(UserModel user) => MenuNavigation(
    label: 'Home',
    iconData: Icons.home_rounded,
    page: EmployeeDashboard(user: user),
  );

  static final _userManagement = MenuNavigation(
    label: 'Users',
    iconData: Icons.people_rounded,
    page: const UserManagementView(),
  );

  static final _hrdUserManagement = MenuNavigation(
    label: 'Employees',
    iconData: Icons.people_alt_rounded,
    page: const HrdUserManagementView(),
  );

  static final _attendance = MenuNavigation(
    label: 'Attendance',
    iconData: Icons.access_time_rounded,
    page: const AttendanceView(),
  );

  static MenuNavigation _leaveManagement(UserModel user) => MenuNavigation(
    label: 'Leave Mgmt',
    iconData: Icons.event_note_rounded,
    page: LeaveManagementView(user: user),
  );

  static final _leaveRequest = MenuNavigation(
    label: 'Leave',
    iconData: Icons.beach_access_rounded,
    page: const LeaveRequestView(),
  );

  static final _reimbursementRequest = MenuNavigation(
    label: 'Reimburse',
    iconData: Icons.receipt_long_rounded,
    page: const ReimbursementRequestView(),
  );

  static final _reimbursementManagement = MenuNavigation(
    label: 'Claims',
    iconData: Icons.payments_rounded,
    page: const ReimbursementManagementView(),
  );

  static final _reports = MenuNavigation(
    label: 'Reports',
    iconData: Icons.bar_chart_rounded,
    page: const ReportsView(),
  );

  static final _settings = MenuNavigation(
    label: 'Settings',
    iconData: Icons.settings_rounded,
    page: const SettingsView(),
  );

  static List<MenuNavigation> getMenusForRole(UserModel user) {
    switch (user.role) {
      case UserRole.admin:
        return [
          _adminDashboard(user),
          _userManagement,
          _attendance,
          _leaveManagement(user),
          _leaveRequest,
          _reimbursementRequest,
          _settings,
        ];

      case UserRole.hrd:
        return [
          _hrdDashboard(user),
          _hrdUserManagement,
          _attendance,
          _leaveManagement(user),
          _reports,
          _leaveRequest,
          _reimbursementRequest,
          _settings,
        ];
      case UserRole.supervisor:
        return [
          _supervisorDashboard(user),
          _attendance,
          _leaveManagement(user),
          _reports,
          _leaveRequest,
          _reimbursementRequest,
          _settings,
        ];

      case UserRole.finance:
        return [
          _financeDashboard(user),
          _attendance,
          _reimbursementManagement,
          _reports,
          _leaveRequest,
          _reimbursementRequest,
          _settings,
        ];

      case UserRole.employee:
        return [
          _employeeDashboard(user),
          _attendance,
          _leaveRequest,
          _reimbursementRequest,
          _settings,
        ];
    }
  }
}

class HomeController extends ChangeNotifier {
  int _selectedIndex = 0;
  List<MenuNavigation> _menuItems = [];
  bool _isDisposed = false;

  int get selectedIndex => _selectedIndex;
  List<MenuNavigation> get menuItems => _menuItems;

  Widget get currentPage {
    if (_menuItems.isEmpty) {
      return const Center(child: Text('No menu items available.'));
    }
    return _menuItems[_selectedIndex].page;
  }

  void init(UserModel user) {
    _menuItems = MenuConfig.getMenusForRole(user);
    if (_menuItems.isNotEmpty && _selectedIndex >= _menuItems.length) {
      _selectedIndex = 0;
    }
    _safeNotify();
  }

  void onItemTapped(int index) {
    if (index < 0 || index >= _menuItems.length) return;
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    _safeNotify();
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
