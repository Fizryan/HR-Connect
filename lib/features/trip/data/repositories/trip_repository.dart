import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';

abstract class TripRepository {
  Future<Either<Failure, List<TripModel>>> getTripMe();
  Future<Either<Failure, List<TripModel>>> getAllTrips();
  Future<Either<Failure, List<TripModel>>> getPendingTrips();
  Future<Either<Failure, TripModel>> getTripById(String id);
  Future<Either<Failure, void>> createTrip(TripData data);
  Future<Either<Failure, void>> approveTrip(String id);
  Future<Either<Failure, void>> rejectTrip(String id);
}
