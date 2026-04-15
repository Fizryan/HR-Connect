import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_provider.dart';

class AdminAccountTabs extends StatefulWidget {
  final ColorScheme colorScheme;
  final AuthProvider authProvider;

  const AdminAccountTabs({super.key, required this.colorScheme, required this.authProvider});

  @override
  State<AdminAccountTabs> createState() => _AdminAccountTabsState();
}

class _AdminAccountTabsState extends State<AdminAccountTabs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // TODO: CRUD
    );
  }
}