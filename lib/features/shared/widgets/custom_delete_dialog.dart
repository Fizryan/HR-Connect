import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> showCustomDeleteDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String expectedConfirmationText,
  required VoidCallback onConfirm,
}) {
  final TextEditingController confirmController = TextEditingController();
  final colorScheme = Theme.of(context).colorScheme;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final isNameMatched =
              confirmController.text.trim().toLowerCase() ==
              expectedConfirmationText.toLowerCase();

          return AlertDialog(
            backgroundColor: colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Please type "$expectedConfirmationText" to confirm:',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: confirmController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: expectedConfirmationText,
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: isNameMatched
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  foregroundColor: colorScheme.onError,
                ),
                onPressed: isNameMatched
                    ? () {
                        context.pop();
                        onConfirm();
                      }
                    : null,
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    },
  );
}
