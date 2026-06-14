import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String hintText;
  final bool isSearchActive;
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchClear;
  final List<Widget>? additionalActions;
  final PreferredSizeWidget? bottom;

  const CustomSearchAppBar({
    super.key,
    required this.title,
    this.hintText = 'Search...',
    required this.isSearchActive,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onSearchClear,
    this.additionalActions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      scrolledUnderElevation: 0,
      title: isSearchActive
          ? SizedBox(
              height: 44.h,
              child: SearchBar(
                controller: searchController,
                hintText: hintText,
                hintStyle: WidgetStateProperty.all(
                  TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                  ),
                ),
                elevation: WidgetStateProperty.all(0),
                backgroundColor: WidgetStateProperty.all(
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
                leading: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 20.sp,
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                trailing: searchQuery.isNotEmpty
                    ? [
                        IconButton(
                          icon: Icon(Icons.clear_rounded, size: 20.sp),
                          onPressed: onSearchClear,
                        ),
                      ]
                    : null,
                onChanged: onSearchChanged,
              ),
            )
          : Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            isSearchActive ? Icons.close_rounded : Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: onSearchToggle,
          tooltip: 'Search & Filter',
        ),
        if (additionalActions != null) ...additionalActions!,
        SizedBox(width: 8.w),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
