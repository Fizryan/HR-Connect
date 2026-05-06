import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_connect/core/di/providers.dart'; 

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Theme Mode',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your preferred theme',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    _buildThemeOption(
                      context: context,
                      ref: ref,
                      title: 'System Default',
                      icon: Icons.brightness_auto_rounded,
                      value: ThemeMode.system,
                      groupValue: currentTheme,
                    ),
                    Divider(
                      height: 1,
                      indent: 56.w,
                      endIndent: 16.w,
                      color: colorScheme.outlineVariant,
                    ),
                    _buildThemeOption(
                      context: context,
                      ref: ref,
                      title: 'Light Mode',
                      icon: Icons.light_mode_rounded,
                      value: ThemeMode.light,
                      groupValue: currentTheme,
                    ),
                    Divider(
                      height: 1,
                      indent: 56.w,
                      endIndent: 16.w,
                      color: colorScheme.outlineVariant,
                    ),
                    _buildThemeOption(
                      context: context,
                      ref: ref,
                      title: 'Dark Mode',
                      icon: Icons.dark_mode_rounded,
                      value: ThemeMode.dark,
                      groupValue: currentTheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required IconData icon,
    required ThemeMode value,
    required ThemeMode groupValue,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = groupValue == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(themeNotifierProvider.notifier).setThemeMode(value);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                size: 24.sp,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}