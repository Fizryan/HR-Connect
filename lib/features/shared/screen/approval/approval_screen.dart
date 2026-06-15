import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/shared/tabs/leave_tab_view.dart';
import 'package:hr_connect/features/shared/tabs/trip_tab_view.dart';
import 'package:hr_connect/features/shared/widgets/custom_search_appbar.dart';

class ApprovalScreen extends ConsumerStatefulWidget {
  const ApprovalScreen({super.key});

  @override
  ConsumerState<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends ConsumerState<ApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomSearchAppBar(
        title: 'Approval',
        hintText: 'Search request description...',
        isSearchActive: _isSearchActive,
        searchController: _searchController,
        searchQuery: _searchQuery,
        onSearchToggle: _toggleSearch,
        onSearchChanged: (value) => setState(() => _searchQuery = value),
        onSearchClear: () {
          _searchController.clear();
          setState(() => _searchQuery = '');
        },
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          indicatorWeight: 1.w,
          tabs: const [
            Tab(text: 'Leaves'),
            Tab(text: 'Trips'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LeaveTabView(searchQuery: _searchQuery, isApprovalMode: true),
          TripTabView(searchQuery: _searchQuery, isApprovalMode: true),
        ],
      ),
    );
  }
}
