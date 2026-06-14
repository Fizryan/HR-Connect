import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_list_notifier.dart';
import 'package:hr_connect/core/constants/enum.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';

final tripMeProvider = FutureProvider<List<TripModel>>((ref) async {
  final repository = ref.read(tripRepositoryProvider);
  final result = await repository.getTripMe();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (trips) => trips,
  );
});

final pendingTripMeProvider = Provider<AsyncValue<List<TripModel>>>((ref) {
  final myTrips = ref.watch(tripMeProvider);

  return myTrips.whenData((trips) {
    return trips.where((trip) => trip.status == RequestStatus.pending).toList();
  });
});

final tripNotifierProvider =
    AsyncNotifierProvider<TripNotifier, List<TripModel>>(TripNotifier.new);

class TripNotifier extends BaseListNotifier<TripModel> {
  DateTime? lastFetchTime;

  @override
  FutureOr<List<TripModel>> build() async {
    final data = await _fetchTripLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<TripModel>> _fetchTripLogic() async {
    final repository = ref.read(tripRepositoryProvider);
    final result = await repository.getAllTrips();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (trips) => trips,
    );
  }

  Future<void> fetchTrips() async {
    if (state.isLoading) return;

    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 10;

    if (isCacheValid && state.hasValue) return;

    await refreshTrips();
  }

  Future<void> refreshTrips() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchTripLogic);

    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<Either<Failure, void>> createTrip(TripData data) async {
    final repository = ref.read(tripRepositoryProvider);
    return handleMutation(
      action: () => repository.createTrip(data),
      onSuccess: (_) {
        refreshTrips();
        ref.invalidate(tripMeProvider);
      },
    );
  }

  Future<Either<Failure, void>> approveTrip(String id) async {
    final repository = ref.read(tripRepositoryProvider);
    return handleMutation(
      action: () => repository.approveTrip(id),
      onSuccess: (_) {
        ref.invalidate(tripMeProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((trip) {
          if (trip.id == id) {
            return trip.copyWith(status: RequestStatus.approved);
          }
          return trip;
        }).toList();
      },
    );
  }

  Future<Either<Failure, void>> rejectTrip(String id) async {
    final repository = ref.read(tripRepositoryProvider);
    return handleMutation(
      action: () => repository.rejectTrip(id),
      onSuccess: (_) {
        ref.invalidate(tripMeProvider);
      },
      optimisticUpdate: (currentList) {
        return currentList.map((trip) {
          if (trip.id == id) {
            return trip.copyWith(status: RequestStatus.rejected);
          }
          return trip;
        }).toList();
      },
    );
  }
}
