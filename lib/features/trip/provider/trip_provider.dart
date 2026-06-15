import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/auth/providers/auth_provider.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';
import 'package:hr_connect/features/trip/provider/base_trip_provider.dart';

final tripMeNotifierProvider =
    AsyncNotifierProvider<TripMeNotifier, List<TripModel>>(TripMeNotifier.new);

class TripMeNotifier extends BaseSharedTripNotifier {
  @override
  Future<Either<Failure, List<TripModel>>> fetchFromRepository() {
    return ref.read(tripRepositoryProvider).getTripMe();
  }
}

final tripNotifierProvider =
    AsyncNotifierProvider<TripNotifier, List<TripModel>>(TripNotifier.new);

class TripNotifier extends BaseSharedTripNotifier {
  @override
  Future<Either<Failure, List<TripModel>>> fetchFromRepository() {
    return ref.read(tripRepositoryProvider).getAllTrips();
  }

  Future<Either<Failure, void>> approveTrip(String id) async {
    final repository = ref.read(tripRepositoryProvider);
    final currenUser = ref.read(authNotifierProvider).value;
    return handleMutation(
      action: () => repository.approveTrip(id),
      onSuccess: (_) {
        ref.invalidate(tripRepositoryProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((trip) {
          if (trip.id == id) {
            return trip.copyWith(
              status: RequestStatus.approved,
              approverId: currenUser?.id,
            );
          }
          return trip;
        }).toList();
      },
    );
  }

  Future<Either<Failure, void>> rejectTrip(String id) async {
    final repository = ref.read(tripRepositoryProvider);
    final currenUser = ref.read(authNotifierProvider).value;
    return handleMutation(
      action: () => repository.rejectTrip(id),
      onSuccess: (_) {
        ref.invalidate(tripNotifierProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((trip) {
          if (trip.id == id) {
            return trip.copyWith(
              status: RequestStatus.rejected,
              approverId: currenUser?.id,
            );
          }
          return trip;
        }).toList();
      },
    );
  }
}
