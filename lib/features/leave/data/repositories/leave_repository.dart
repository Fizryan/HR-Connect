import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/leave/data/model/leave_request_model.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<LeaveRequestModel>>> getLeaveRequests();
  Future<Either<Failure, LeaveRequestModel>> getLeaveRequestById(String id);
  Future<Either<Failure, LeaveRequestModel>> updateLeaveRequest(String id, Map<String, dynamic> updateData);
  Future<Either<Failure, void>> deleteLeaveRequest(String id);
  Future<Either<Failure, void>> approveLeaveRequest(String id);
  Future<Either<Failure, void>> rejectLeaveRequest(String id);
}