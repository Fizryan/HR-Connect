import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterRow extends StatelessWidget {
  final List<Widget> filters;

  const CustomFilterRow({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: filters,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: colorScheme.primaryContainer,
        onSelected: onSelected,
      ),
    );
  }
}

class CustomFilterDivider extends StatelessWidget {
  const CustomFilterDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 1.w,
      height: 20.h,
      color: colorScheme.outlineVariant,
      margin: EdgeInsets.only(right: 16.w, left: 8.w),
    );
  }
}
