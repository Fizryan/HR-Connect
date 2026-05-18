import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/business_trip/data/model/business_trip_model.dart';

abstract class BusinessTripRepository {
  Future<Either<Failure, List<BusinessTripModel>>> getBusinessTrip();
  Future<Either<Failure, BusinessTripModel>> getBusinessTripById(String id);
  Future<Either<Failure, BusinessTripModel>> updateBusinessTrip(
    String id,
    Map<String, dynamic> updateData,
  );
  Future<Either<Failure, void>> deleteBusinessTrip(String id);
  Future<Either<Failure, void>> approveBusinessTrip(String id);
  Future<Either<Failure, void>> rejectBusinessTrip(String id);
}
