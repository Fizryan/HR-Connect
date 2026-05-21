import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/const/enums.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/business_trip/data/model/business_trip_model.dart';

final businessNotifierProvider =
    AsyncNotifierProvider<BusinessNotifier, List<BusinessTripModel>>(
      BusinessNotifier.new,
    );

class BusinessNotifier extends AsyncNotifier<List<BusinessTripModel>> {
  DateTime? lastFetchTime;

  @override
  FutureOr<List<BusinessTripModel>> build() async {
    final data = await _fetchBusinessTripLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<List<BusinessTripModel>> _fetchBusinessTripLogic() async {
    final repository = ref.read(businessRepositoryProvider);
    final result = await repository.getBusinessTrip();

    return result.fold(
      (failure) => throw failure.message,
      (businessTrip) => businessTrip,
    );
  }

  Future<void> fetchBusinessTrip() async {
    if (state.isLoading) return;

    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 15;

    if (isCacheValid && state.hasValue && state.value!.isNotEmpty) {
      return;
    }

    await refreshBusinessTrip();
  }

  Future<void> refreshBusinessTrip() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchBusinessTripLogic);
    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }

  Future<void> fetchBusinessTripById(String id) async {
    final repository = ref.read(businessRepositoryProvider);
    final result = await repository.getBusinessTripById(id);

    result.fold(
      (failure) {
        debugPrint('Failed to fetch business trip: ${failure.message}');
      },
      (fetchedBusinessTrip) {
        if (state.hasValue) {
          final updatedList = state.value!.map((businessTrip) {
            return businessTrip.id == id ? fetchedBusinessTrip : businessTrip;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> _handleMutation<T>({
    required Future<Either<Failure, T>> Function() action,
    List<BusinessTripModel> Function(List<BusinessTripModel> currentList)?
    optimisticUpdate,
    void Function(T successData)? onSuccess,
  }) async {
    final previousState = state;

    if (optimisticUpdate != null && previousState.hasValue) {
      state = AsyncValue.data(optimisticUpdate(previousState.value!));
    }

    final result = await action();

    result.fold(
      (failure) {
        state = previousState.whenData((_) => throw failure.message);
        Future.delayed(const Duration(seconds: 2), () {
          if (state.hasError && previousState.hasValue) {
            state = AsyncValue.data(previousState.value!);
          }
        });
      },
      (successData) {
        if (onSuccess != null) {
          onSuccess(successData);
        }
      },
    );
  }

  Future<void> updateBusinessTrip(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    await _handleMutation(
      action: () => ref
          .read(businessRepositoryProvider)
          .updateBusinessTrip(id, updateData),
      onSuccess: (updatedBusinessTrip) {
        if (state.hasValue) {
          final updatedList = state.value!.map((business) {
            return business.id == id ? updatedBusinessTrip : business;
          }).toList();
          state = AsyncValue.data(updatedList);
        }
      },
    );
  }

  Future<void> approveBusinessTrip(String id) async {
    await _handleMutation(
      action: () =>
          ref.read(businessRepositoryProvider).approveBusinessTrip(id),
      optimisticUpdate: (current) => current.map((business) {
        return business.id == id
            ? business.copyWith(status: RequestStatus.approved)
            : business;
      }).toList(),
    );
  }

  Future<void> rejectBusinessTrip(String id, String reason) async {
    await _handleMutation(
      action: () => ref.read(businessRepositoryProvider).rejectBusinessTrip(id, reason),
      optimisticUpdate: (current) => current.map((business) {
        return business.id == id
            ? business.copyWith(status: RequestStatus.rejected)
            : business;
      }).toList(),
    );
  }

  Future<void> createBusinessTrip(Map<String, dynamic> request) async {
    await _handleMutation(
      action: () => ref.read(businessRepositoryProvider).createBusinessTrip(request),
      onSuccess: (_) {
        fetchBusinessTrip();
      },
    );
  }
}
