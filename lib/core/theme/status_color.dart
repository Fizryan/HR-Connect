import 'package:flutter/material.dart';
import 'package:hr_connect/core/constants/enum.dart';

class StatusColor {
  static Color getStatusColor(ColorScheme colorScheme, RequestStatus status) {
    switch (status) {
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return colorScheme.error;
      case RequestStatus.pending:
      default:
        return Colors.orange;
    }
  }

  static IconData getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.approved:
        return Icons.check_circle_outline_rounded;
      case RequestStatus.rejected:
        return Icons.cancel_outlined;
      case RequestStatus.pending:
      default:
        return Icons.hourglass_empty_rounded;
    }
  }
}
