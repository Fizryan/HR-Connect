import 'package:flutter/material.dart';
import 'package:hr_connect/features/widgets/presentation/features/request/business_trip_tab.dart';
import 'package:hr_connect/features/widgets/presentation/features/request/leave_request_tab.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: colorScheme.onSurface,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Leave'),
                  Tab(text: 'Business'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    LeaveRequestTab(),
                    BusinessTripTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          heroTag: 'request_fab',
          onPressed: () {},
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          elevation: 0,
          child: const Icon(Icons.add_rounded, size: 24),
        ),
      ),
    );
  }
}
