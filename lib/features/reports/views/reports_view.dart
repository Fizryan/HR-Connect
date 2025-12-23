import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/controllers/auth_controller.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/reports/controllers/reports_controller.dart';
import 'package:hr_connect/features/reports/services/pdf_report_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = context.read<AuthController>();
      final reportsController = context.read<ReportsController>();
      if (authController.user != null) {
        reportsController.setUserRole(authController.user!.role);
      }
      reportsController.fetchReportData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<ReportsController>(
          builder: (context, controller, _) {
            if (controller.isLoading && controller.reportData == null) {
              return const LoadingState(message: 'Loading report data...');
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchReportData(forceRefresh: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      title: 'Reports',
                      subtitle: 'Analytics and insights',
                    ),
                    SizedBox(height: 16.h),
                    _buildPeriodSelector(context, controller),
                    SizedBox(height: 24.h),
                    _buildMetricsGrid(theme, controller),
                    SizedBox(height: 24.h),
                    _buildReportsList(theme, controller),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(
    BuildContext context,
    ReportsController controller,
  ) {
    return AppFilterChips(
      filters: const ['This Week', 'This Month', 'This Quarter', 'This Year'],
      currentFilter: controller.selectedPeriod,
      onFilterChanged: controller.setPeriod,
    );
  }

  Widget _buildMetricsGrid(ThemeData theme, ReportsController controller) {
    final data = controller.reportData;
    final role = controller.currentUserRole;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final isHrd = role == UserRole.hrd || role == UserRole.admin;
    final isFinance = role == UserRole.finance;
    final isSupervisor = role == UserRole.supervisor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          if (!isFinance || isHrd)
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Attendance Rate',
                    value: '${data?.attendanceRate.toStringAsFixed(1) ?? '0'}%',
                    change: '+2.3%',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _MetricCard(
                    title: 'Leave Utilization',
                    value:
                        '${data?.leaveUtilization.toStringAsFixed(0) ?? '0'}%',
                    change: '-5%',
                    icon: Icons.trending_down,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          if (isFinance || isHrd) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Budget Used',
                    value: currencyFormat.format(
                      data?.paidReimbursementAmount ?? 0,
                    ),
                    change:
                        '${controller.budgetUtilization.toStringAsFixed(1)}%',
                    icon: Icons.account_balance_wallet,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _MetricCard(
                    title: 'Budget Remaining',
                    value: currencyFormat.format(controller.remainingBudget),
                    change:
                        '${(100 - controller.budgetUtilization).toStringAsFixed(1)}%',
                    icon: Icons.savings,
                    color: controller.remainingBudget > 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
          if (isHrd || isSupervisor) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Active Employees',
                    value: '${data?.activeEmployees ?? 0}',
                    change:
                        '+${data?.totalEmployees != null ? data!.totalEmployees - data.activeEmployees : 0}',
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _MetricCard(
                    title: 'Avg Work Hours',
                    value: '${data?.avgWorkHours.toStringAsFixed(1) ?? '0'}h',
                    change: '+0.3h',
                    icon: Icons.access_time,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
          if (isFinance || isHrd) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Pending Reimburse',
                    value: '${data?.pendingReimbursements ?? 0}',
                    change: currencyFormat.format(
                      data?.pendingReimbursementAmount ?? 0,
                    ),
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _MetricCard(
                    title: 'Approved Reimburse',
                    value: '${data?.approvedReimbursements ?? 0}',
                    change: currencyFormat.format(
                      data?.approvedReimbursementAmount ?? 0,
                    ),
                    icon: Icons.check_circle,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportsList(ThemeData theme, ReportsController controller) {
    final role = controller.currentUserRole;
    final allReports = [
      _ReportItem(
        'Attendance Summary',
        'Daily, weekly, and monthly attendance overview',
        Icons.calendar_today,
        Colors.blue,
        ReportType.attendance,
      ),
      _ReportItem(
        'Leave Report',
        'Leave utilization and trends analysis',
        Icons.beach_access,
        Colors.orange,
        ReportType.leave,
      ),
      _ReportItem(
        'Working Hours',
        'Overtime and work hour analysis',
        Icons.access_time,
        Colors.indigo,
        ReportType.workingHours,
      ),
      _ReportItem(
        'Reimbursement Report',
        'Expense reimbursement and budget analysis',
        Icons.receipt_long,
        Colors.teal,
        ReportType.reimbursement,
      ),
      _ReportItem(
        'Full HR Report',
        'Comprehensive HR analytics report',
        Icons.assessment,
        Colors.purple,
        ReportType.full,
      ),
    ];

    List<_ReportItem> reports;
    switch (role) {
      case UserRole.hrd:
      case UserRole.admin:
        reports = allReports;
        break;
      case UserRole.supervisor:
        reports = allReports
            .where((r) => r.type == ReportType.attendance)
            .toList();
        break;
      case UserRole.finance:
        reports = allReports
            .where((r) => r.type == ReportType.reimbursement)
            .toList();
        break;
      default:
        reports = [];
    }

    if (reports.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.lock, size: 48.sp, color: theme.colorScheme.outline),
              SizedBox(height: 12.h),
              Text(
                'No reports available for your role',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'Available Reports',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          itemCount: reports.length,
          itemBuilder: (context, index) =>
              _ReportTile(report: reports[index], controller: controller),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

enum ReportType { attendance, leave, workingHours, reimbursement, full }

class _ReportItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final ReportType type;

  _ReportItem(this.title, this.description, this.icon, this.color, this.type);
}

class _ReportTile extends StatelessWidget {
  final _ReportItem report;
  final ReportsController controller;

  const _ReportTile({required this.report, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: report.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(report.icon, color: report.color, size: 24.sp),
        ),
        title: Text(
          report.title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          report.description,
          style: TextStyle(
            fontSize: 12.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.picture_as_pdf, color: Colors.red, size: 24.sp),
          onPressed: () => _exportToPdf(context),
          tooltip: 'Export to PDF',
        ),
      ),
    );
  }

  Future<void> _exportToPdf(BuildContext context) async {
    final data = controller.reportData;
    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data available to export')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      switch (report.type) {
        case ReportType.attendance:
          await PdfReportService.generateAttendanceReport(
            context,
            data,
            controller.startDate,
            controller.endDate,
          );
          break;
        case ReportType.leave:
          await PdfReportService.generateLeaveReport(
            context,
            data,
            controller.startDate,
            controller.endDate,
          );
          break;
        case ReportType.workingHours:
          await PdfReportService.generateWorkingHoursReport(
            context,
            data,
            controller.startDate,
            controller.endDate,
          );
          break;
        case ReportType.reimbursement:
          await PdfReportService.generateReimbursementReport(
            context,
            data,
            controller.startDate,
            controller.endDate,
            ReportsController.totalAnnualBudget,
          );
          break;
        case ReportType.full:
          await PdfReportService.generateFullReport(
            context,
            data,
            controller.startDate,
            controller.endDate,
          );
          break;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = change.startsWith('+');

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 18.sp, color: color),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: (isPositive ? Colors.green : Colors.orange)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.orange,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
