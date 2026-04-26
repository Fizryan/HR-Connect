import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<LeaveModel>>> getAllLeaves();
  Future<Either<Failure, LeaveModel>> getLeaveByUid(String uid);
  Future<Either<Failure, LeaveModel>> createLeave(LeaveModel leave);
  Future<Either<Failure, LeaveModel>> updateLeave(LeaveModel leave);
  Future<Either<Failure, void>> deleteLeave(String uid);
}
