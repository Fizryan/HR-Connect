import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/constants/shared_preferences.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';
import 'package:hr_connect/features/trip/data/remote/trip_remote.dart';
import 'package:hr_connect/features/trip/data/repositories/trip_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripRepositoryImp extends BaseRepository implements TripRepository {
  final TripRemote remoteDataSource;
  final SharedPreferences sharedPreferences;

  TripRepositoryImp({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<TripModel>>> getTripMe() async {
    final apiResult = await sourceCall(
      () async {
        final trips = await remoteDataSource.getTripMe();
        final tripListJson = trips.map((trip) => trip.toJson()).toList();

        await sharedPreferences.setString(
          SharedPrefs.cachedTrips,
          jsonEncode(tripListJson),
        );
        return trips;
      },
      Intl.message(
        'Failed to load trip information.',
        name: 'loadTripMeFailed',
      ),
    );

    return apiResult.fold(
      (failure) {
        logger.e('[TripRepository] API call failed, loading from cache.');
        final cachedData = sharedPreferences.getString(SharedPrefs.cachedTrips);

        if (cachedData != null && cachedData.isNotEmpty) {
          final decodeTrips = jsonDecode(cachedData) as List<dynamic>;
          final cachedTrips = decodeTrips
              .map((trip) => TripModel.fromJson(trip as Map<String, dynamic>))
              .toList();
          return Right(cachedTrips);
        }

        return Left(failure);
      },
      (trips) {
        return Right(trips);
      },
    );
  }

  @override
  Future<Either<Failure, List<TripModel>>> getAllTrips() async {
    return sourceCall(
      remoteDataSource.getAllTrips,
      Intl.message('Failed to load trips.', name: 'loadTripsFailed'),
    );
  }

  @override
  Future<Either<Failure, List<TripModel>>> getPendingTrips() async {
    return sourceCall(
      remoteDataSource.getPendingTrips,
      Intl.message(
        'Failed to load pending trips.',
        name: 'loadPendingTripsFailed',
      ),
    );
  }

  @override
  Future<Either<Failure, TripModel>> getTripById(String id) async {
    return sourceCall(
      () => remoteDataSource.getTripById(id),
      Intl.message('Failed to load trip.', name: 'loadTripFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> createTrip(TripData data) async {
    return sourceCall(
      () => remoteDataSource.createTrip(data),
      Intl.message('Failed to create trip.', name: 'createTripFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> approveTrip(String id) async {
    return sourceCall(
      () => remoteDataSource.approveTrip(id),
      Intl.message('Failed to approve trip.', name: 'approveTripFailed'),
    );
  }

  @override
  Future<Either<Failure, void>> rejectTrip(String id) async {
    return sourceCall(
      () => remoteDataSource.rejectTrip(id),
      Intl.message('Failed to reject trip.', name: 'rejectTripFailed'),
    );
  }
}
