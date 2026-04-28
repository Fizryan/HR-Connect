import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/logic/account/data/model/account_model.dart';
import 'package:hr_connect/features/logic/account/providers/account_provider.dart';
import 'package:hr_connect/features/logic/account/providers/account_state.dart';
import 'package:hr_connect/features/widgets/presentation/etc/account/create_account_screen.dart';
import 'package:hr_connect/features/widgets/presentation/etc/account/edit_account_screen.dart';
import 'package:hr_connect/features/widgets/presentation/role/admin/admin_account_card.dart';
import 'package:hr_connect/features/widgets/presentation/shared/dialog_widget.dart';

class AdminAccountsTab extends StatefulWidget {
  final ColorScheme colorScheme;
  final AccountProvider accountProvider;

  const AdminAccountsTab({
    super.key,
    required this.colorScheme,
    required this.accountProvider,
  });

  @override
  State<AdminAccountsTab> createState() => _AdminAccountsTabState();
}

class _AdminAccountsTabState extends State<AdminAccountsTab> {
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildFilterSection(widget.colorScheme),
          Expanded(
            child: ValueListenableBuilder<AccountState>(
              valueListenable: widget.accountProvider,
              builder: (context, state, child) {
                return state.maybeWhen(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (message) => Center(child: Text('Error: $message')),
                  dataList: (accounts) => _buildGrid(accounts, widget.colorScheme),
                  orElse: () => const Center(child: Text('No Data Available')),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.colorScheme.primary,
        foregroundColor: widget.colorScheme.onPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminCreateAccountScreen(
                colorScheme: widget.colorScheme,
                accountProvider: widget.accountProvider,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterSection(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => DialogWidget.showInformationDialog(
              context,
              colorScheme,
              'Information',
              'Search accounts by typing an email address.',
            ),
            color: colorScheme.onSurface,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search accounts...',
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
        ],
      ),
    );
  }

  Widget _buildGrid(List<AccountModel> accounts, ColorScheme colorScheme) {
    final filteredAccounts = accounts.where((account) {
      return account.email.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredAccounts.isEmpty) {
      return const Center(child: Text('No accounts found.'));
    }

    final totalPages = (filteredAccounts.length / _itemsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filteredAccounts.length);
    final paginatedAccounts = filteredAccounts.sublist(startIndex, endIndex);

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
            itemCount: paginatedAccounts.length,
            itemBuilder: (context, index) {
              return AdminAccountCard(
                account: paginatedAccounts[index],
                colorScheme: colorScheme,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminEditAccountScreen(
                        colorScheme: colorScheme,
                        account: paginatedAccounts[index],
                        accountProvider: widget.accountProvider,
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
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
          color: colorScheme.onSurface,
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
          onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
          color: colorScheme.onSurface,
        ),
      ],
    );
  }
}