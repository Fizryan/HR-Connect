import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_list_notifier.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';
import 'package:hr_connect/features/trip/provider/trip_provider.dart';

abstract class BaseSharedTripNotifier extends BaseListNotifier<TripModel> {
  DateTime? lastFetchTime;

  Future<Either<Failure, List<TripModel>>> fetchFromRepository();

  @override
  FutureOr<List<TripModel>> build() async {
    final data = await _fetchLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<TripModel>> _fetchLogic() async {
    final result = await fetchFromRepository();
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
    state = await AsyncValue.guard(_fetchLogic);

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
        if (this is TripMeNotifier) {
          ref.invalidate(tripNotifierProvider);
        } else if (this is TripNotifier) {
          ref.invalidate(tripMeNotifierProvider);
        }
      },
    );
  }
}
