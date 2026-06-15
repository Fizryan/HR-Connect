import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/leave/providers/base_leave_provider.dart';

final leaveMeNotifierProvider =
    AsyncNotifierProvider<LeaveMeNotifier, List<LeaveModel>>(
      LeaveMeNotifier.new,
    );

class LeaveMeNotifier extends BaseSharedLeaveNotifier {
  @override
  Future<Either<Failure, List<LeaveModel>>> fetchFromRepository() {
    return ref.read(leaveRepositoryProvider).getLeaveMe();
  }
}

final leaveNotifierProvider =
    AsyncNotifierProvider<LeaveNotifier, List<LeaveModel>>(LeaveNotifier.new);

class LeaveNotifier extends BaseSharedLeaveNotifier {
  @override
  Future<Either<Failure, List<LeaveModel>>> fetchFromRepository() {
    return ref.read(leaveRepositoryProvider).getAllLeaves();
  }

  Future<Either<Failure, void>> approveLeave(String id) async {
    final repository = ref.read(leaveRepositoryProvider);
    final currentUser = ref.read(authNotifierProvider).value;
    return handleMutation(
      action: () => repository.approveLeave(id),
      onSuccess: (_) {
        ref.invalidate(leaveRepositoryProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((leave) {
          if (leave.id == id) {
            return leave.copyWith(
              status: RequestStatus.approved,
              approverId: currentUser?.id,
            );
          }
          return leave;
        }).toList();
      },
    );
  }

  Future<Either<Failure, void>> rejectLeave(String id) async {
    final repository = ref.read(leaveRepositoryProvider);
    final currentUser = ref.read(authNotifierProvider).value;
    return handleMutation(
      action: () => repository.rejectLeave(id),
      onSuccess: (_) {
        ref.invalidate(leaveNotifierProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((leave) {
          if (leave.id == id) {
            return leave.copyWith(
              status: RequestStatus.rejected,
              approverId: currentUser?.id,
            );
          }
          return leave;
        }).toList();
      },
    );
  }
}
