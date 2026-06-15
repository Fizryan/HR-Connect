import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<LeaveModel>>> getLeaveMe();
  Future<Either<Failure, List<LeaveModel>>> getAllLeaves();
  Future<Either<Failure, List<LeaveModel>>> getPendingLeaves();
  Future<Either<Failure, LeaveModel>> getLeaveById(String id);
  Future<Either<Failure, void>> createLeave(LeaveData data);
  Future<Either<Failure, void>> approveLeave(String id);
  Future<Either<Failure, void>> rejectLeave(String id);
}
