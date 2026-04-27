import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/logic/overtime/data/models/overtime_model.dart';

abstract class OvertimeRepository {
  Future<Either<Failure, List<OvertimeModel>>> getAllOvertimeRequests();
  Future<Either<Failure, OvertimeModel>> getOvertimeById(String uid);
  Future<Either<Failure, OvertimeModel>> createOvertimeRequest(
    OvertimeModel overtime,
  );
  Future<Either<Failure, OvertimeModel>> updateOvertimeStatus(
    OvertimeModel overtime,
  );
  Future<Either<Failure, void>> deleteOvertimeRequest(String uid);
}
