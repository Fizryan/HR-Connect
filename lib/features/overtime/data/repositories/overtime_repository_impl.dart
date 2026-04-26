import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/overtime/data/datasource/overtime_remote.dart';
import 'package:hr_connect/features/overtime/data/models/overtime_model.dart';
import 'package:hr_connect/features/overtime/data/repositories/overtime_repository.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  final OvertimeRemote remoteDataSource;

  OvertimeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OvertimeModel>>> getAllOvertimeRequests() async {
    try {
      final result = await remoteDataSource.getAllOvertimesRequests();
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OvertimeModel>> getOvertimeById(String uid) async {
    try {
      final result = await remoteDataSource.getOvertimeByUid(uid);
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OvertimeModel>> createOvertimeRequest(
    OvertimeModel overtime,
  ) async {
    try {
      final result = await remoteDataSource.createOvertimeRequest(
        overtime.toJson(),
      );
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OvertimeModel>> updateOvertimeStatus(
    OvertimeModel overtime,
  ) async {
    try {
      final result = await remoteDataSource.updateOvertimeStatus(
        overtime.uid,
        overtime.toJson(),
      );
      return Right(result);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOvertimeRequest(String uid) async {
    try {
      await remoteDataSource.deleteOvertimeRequest(uid);
      return const Right(null);
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) return Left(e as Failure);
      return Left(ServerFailure(e.toString()));
    }
  }
}
