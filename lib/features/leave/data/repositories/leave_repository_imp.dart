import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/constants/shared_preferences.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/leave/data/remote/leave_remote.dart';
import 'package:hr_connect/features/leave/data/repositories/leave_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRepositoryImp extends BaseRepository implements LeaveRepository {
  final LeaveRemote remoteDataSource;
  final SharedPreferences sharedPreferences;

  LeaveRepositoryImp({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<LeaveModel>>> getLeaveMe() async {
    final apiResult = await sourceCall(
      () async {
        final leaves = await remoteDataSource.getLeaveMe();
        final leaveListJson = leaves.map((leave) => leave.toJson()).toList();

        await sharedPreferences.setString(
          SharedPrefs.cachedLeaves,
          jsonEncode(leaveListJson),
        );

        return leaves;
      },
      Intl.message(
        'Failed to load leave information.',
        name: 'loadLeaveMeFailed',
      ),
    );

    return apiResult.fold(
      (failure) {
        logger.e('[LeaveRepository] API call failed, loading from cache.');
        final cachedData = sharedPreferences.getString(
          SharedPrefs.cachedLeaves,
        );

        if (cachedData != null && cachedData.isNotEmpty) {
          final decodeLeaves = jsonDecode(cachedData) as List<dynamic>;
          final cachedLeaves = decodeLeaves
              .map(
                (leave) => LeaveModel.fromJson(leave as Map<String, dynamic>),
              )
              .toList();
          return Right(cachedLeaves);
        }

        return Left(failure);
      },
      (leaves) {
        return Right(leaves);
      },
    );
  }

  @override
  Future<Either<Failure, List<LeaveModel>>> getAllLeaves() async {
    return sourceCall(
      remoteDataSource.getAllLeaves,
      Intl.message('Failed to load leaves.', name: 'loadLeavesFailed'),
    );
  }

  @override
  Future<Either<Failure, List<LeaveModel>>> getPendingLeaves() async {
    return sourceCall(
      remoteDataSource.getPendingLeaves,
      Intl.message(
        'Failed to load pending leaves.',
        name: 'loadPendingLeavesFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, LeaveModel>> getLeaveById(String id) async {
    return sourceCall(
      () => remoteDataSource.getLeaveById(id),
      Intl.message('Failed to load leave.', name: 'loadLeaveFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> createLeave(LeaveData data) async {
    return sourceCall(
      () => remoteDataSource.createLeave(data),
      Intl.message('Failed to create leave.', name: 'createLeaveFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> approveLeave(String id) async {
    return sourceCall(
      () => remoteDataSource.approveLeave(id),
      Intl.message('Failed to approve leave.', name: 'approveLeaveFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> rejectLeave(String id, String reason) async {
    return sourceCall(
      () => remoteDataSource.rejectLeave(id, reason),
      Intl.message('Failed to reject leave.', name: 'rejectLeaveFailed'),
    );
  }
}
