import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';

class ApprovalPolicy {
  static bool canApprove(UserData? requester, UserData? approver) {
    if (requester == null || approver == null) return false;
    if (requester == approver) return false;
    if (approver.role == Role.admin && requester != approver) return true;
    return _isStrictlyAbove(requester.role, approver.role);
  }

  static bool _isStrictlyAbove(Role requester, Role approver) {
    switch (approver) {
      case Role.admin:
        return requester == Role.director;
      case Role.director:
        return requester == Role.manager;
      case Role.manager:
        return requester == Role.supervisor;
      case Role.supervisor:
        return requester == Role.staff;
      default:
        return false;
    }
  }
}
