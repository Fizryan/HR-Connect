import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> showCustomConfirmDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String confirmButtonText,
  required VoidCallback onConfirm,
  bool isDestructive = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
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
            color: isDestructive ? colorScheme.error : colorScheme.primary,
          ),
        ),
        content: Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant,
          ),
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
              backgroundColor: isDestructive
                  ? colorScheme.error
                  : colorScheme.primary,
              foregroundColor: isDestructive
                  ? colorScheme.onError
                  : colorScheme.onPrimary,
            ),
            onPressed: () {
              context.pop();
              onConfirm();
            },
            child: Text(confirmButtonText),
          ),
        ],
      );
    },
  );
}
