import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/widgets/common_widgets.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/attendance/controllers/attendance_controller.dart';
import 'package:hr_connect/features/reports/controllers/reports_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinanceDashboard extends StatefulWidget {
  final UserModel user;

  const FinanceDashboard({super.key, required this.user});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReportsController>().fetchReportData();
        context.read<AttendanceController>().fetchTodayAttendance(
          widget.user.uid,
        );
      }
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
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
              return const LoadingState(message: 'Loading financial data...');
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchReportData(forceRefresh: true),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32.w : 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(theme),
                        SizedBox(height: 24.h),
                        _QuickActionsSection(
                          userId: widget.user.uid,
                          employeeName: widget.user.fullname,
                        ),
                        SizedBox(height: 24.h),
                        _buildFinancialOverview(theme, controller, isWide),
                        SizedBox(height: 24.h),
                        _buildReimbursementSummary(theme, controller),
                        SizedBox(height: 24.h),
                        _buildExpenseBreakdown(theme, controller),
                        SizedBox(height: 24.h),
                        _buildRecentReimbursements(theme, controller),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RoleBadge(label: 'FINANCE', color: Colors.teal),
        SizedBox(height: 8.h),
        Text(
          _greeting,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.user.fullname,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: 12.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialOverview(
    ThemeData theme,
    ReportsController controller,
    bool isWide,
  ) {
    final data = controller.reportData;
    final totalBudget = ReportsController.totalAnnualBudget;
    final usedBudget = data?.paidReimbursementAmount ?? 0;
    final remainingBudget = controller.remainingBudget;
    final utilization = controller.budgetUtilization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Budget Overview'),
        SizedBox(height: 12.h),
        if (isWide)
          Row(
            children: [
              Expanded(
                child: _FinanceCard(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: Colors.blue,
                  title: 'Total Budget',
                  value: _currencyFormat.format(totalBudget),
                  change: 'Annual',
                  isPositive: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _FinanceCard(
                  icon: Icons.trending_down_rounded,
                  iconColor: Colors.orange,
                  title: 'Budget Used',
                  value: _currencyFormat.format(usedBudget),
                  change: '${utilization.toStringAsFixed(1)}%',
                  isPositive: false,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _FinanceCard(
                  icon: Icons.savings_rounded,
                  iconColor: remainingBudget > 0 ? Colors.green : Colors.red,
                  title: 'Remaining',
                  value: _currencyFormat.format(remainingBudget),
                  change: '${(100 - utilization).toStringAsFixed(1)}%',
                  isPositive: remainingBudget > 0,
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _FinanceCard(
                      icon: Icons.account_balance_wallet_rounded,
                      iconColor: Colors.blue,
                      title: 'Total Budget',
                      value: _currencyFormat.format(totalBudget),
                      change: 'Annual',
                      isPositive: true,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _FinanceCard(
                      icon: Icons.trending_down_rounded,
                      iconColor: Colors.orange,
                      title: 'Budget Used',
                      value: _currencyFormat.format(usedBudget),
                      change: '${utilization.toStringAsFixed(1)}%',
                      isPositive: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _FinanceCard(
                icon: Icons.savings_rounded,
                iconColor: remainingBudget > 0 ? Colors.green : Colors.red,
                title: 'Remaining Budget',
                value: _currencyFormat.format(remainingBudget),
                change: '${(100 - utilization).toStringAsFixed(1)}%',
                isPositive: remainingBudget > 0,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildReimbursementSummary(
    ThemeData theme,
    ReportsController controller,
  ) {
    final data = controller.reportData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(title: 'Reimbursement Summary'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                DateFormat('yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        AppCard(
          child: Column(
            children: [
              _StatRow(
                label: 'Pending Requests',
                value: '${data?.pendingReimbursements ?? 0}',
                subValue: _currencyFormat.format(
                  data?.pendingReimbursementAmount ?? 0,
                ),
                icon: Icons.pending_actions,
                color: Colors.orange,
              ),
              Divider(height: 24.h),
              _StatRow(
                label: 'Approved (Unpaid)',
                value: '${data?.approvedReimbursements ?? 0}',
                subValue: _currencyFormat.format(
                  data?.approvedReimbursementAmount ?? 0,
                ),
                icon: Icons.check_circle_outline,
                color: Colors.blue,
              ),
              Divider(height: 24.h),
              _StatRow(
                label: 'Paid',
                value: '${data?.paidReimbursements ?? 0}',
                subValue: _currencyFormat.format(
                  data?.paidReimbursementAmount ?? 0,
                ),
                icon: Icons.payments,
                color: Colors.green,
              ),
              Divider(height: 24.h),
              _StatRow(
                label: 'Rejected',
                value: '${data?.rejectedReimbursements ?? 0}',
                subValue: '-',
                icon: Icons.cancel_outlined,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseBreakdown(ThemeData theme, ReportsController controller) {
    final data = controller.reportData;
    final reimbursementByType = data?.reimbursementByType ?? {};
    final total = reimbursementByType.values.fold(0.0, (a, b) => a + b);

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Expense by Category'),
        SizedBox(height: 12.h),
        AppCard(
          child: reimbursementByType.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Center(
                    child: Text(
                      'No expense data available',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: reimbursementByType.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                        final idx = entry.key;
                        final item = entry.value;
                        final percentage = total > 0
                            ? (item.value / total) * 100
                            : 0;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: idx < reimbursementByType.length - 1
                                ? 16.h
                                : 0,
                          ),
                          child: _ExpenseItem(
                            label: item.key,
                            percentage: percentage.toInt(),
                            amount: _currencyFormat.format(item.value),
                            color: colors[idx % colors.length],
                          ),
                        );
                      })
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildRecentReimbursements(
    ThemeData theme,
    ReportsController controller,
  ) {
    final data = controller.reportData;
    final recentRecords = (data?.reimbursementRecords ?? []).take(5).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Recent Reimbursements'),
        SizedBox(height: 12.h),
        AppCard(
          child: recentRecords.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Center(
                    child: Text(
                      'No recent reimbursements',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                )
              : Column(
                  children: recentRecords.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final record = entry.value;
                    final isPaid = record.status.name == 'paid';
                    final isRejected = record.status.name == 'rejected';

                    return Column(
                      children: [
                        _TransactionItem(
                          title: record.employeeName,
                          subtitle: record.typeText,
                          amount: _currencyFormat.format(record.amount),
                          status: record.statusText,
                          date: DateFormat('MMM d').format(record.createdAt),
                          statusColor: isPaid
                              ? Colors.green
                              : isRejected
                              ? Colors.red
                              : Colors.orange,
                        ),
                        if (idx < recentRecords.length - 1)
                          Divider(height: 24.h),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _RoleBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String change;
  final bool isPositive;

  const _FinanceCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;
  final IconData icon;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.subValue,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 20.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                subValue,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final String label;
  final int percentage;
  final String amount;
  final Color color;

  const _ExpenseItem({
    required this.label,
    required this.percentage,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6.h,
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String status;
  final String date;
  final Color statusColor;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.date,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.receipt_long, color: statusColor, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                amount,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  final String userId;
  final String employeeName;

  const _QuickActionsSection({
    required this.userId,
    required this.employeeName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        final todayAttendance = controller.todayAttendance;
        final hasCheckedIn = todayAttendance?.checkIn != null;
        final hasCheckedOut = todayAttendance?.checkOut != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'Quick Actions'),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: hasCheckedIn ? 'Checked In' : 'Check In',
                    icon: Icons.login,
                    color: hasCheckedIn ? Colors.grey : Colors.green,
                    enabled: !hasCheckedIn,
                    onTap: () => _handleCheckIn(context, controller),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _ActionCard(
                    title: hasCheckedOut ? 'Checked Out' : 'Check Out',
                    icon: Icons.logout,
                    color: hasCheckedOut
                        ? Colors.grey
                        : (hasCheckedIn ? Colors.orange : Colors.grey),
                    enabled: hasCheckedIn && !hasCheckedOut,
                    onTap: () => _handleCheckOut(context, controller),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCheckIn(
    BuildContext context,
    AttendanceController controller,
  ) async {
    final result = await controller.checkIn(userId, employeeName: employeeName);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleCheckOut(
    BuildContext context,
    AttendanceController controller,
  ) async {
    final result = await controller.checkOut(userId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: enabled ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withValues(alpha: enabled ? 0.3 : 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color.withValues(alpha: enabled ? 1.0 : 0.5),
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: enabled ? 1.0 : 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
