import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/features/widgets/shared/menu.dart';

class AdminDashboard extends StatelessWidget {
  final ColorScheme colorScheme;

  const AdminDashboard({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Menu(colorScheme: colorScheme)
        ],
      ),
    );
  }
}
