import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';

abstract class BaseListNotifier<T> extends AsyncNotifier<List<T>> {
  Future<Either<Failure, R>> handleMutation<R>({
    required Future<Either<Failure, R>> Function() action,
    List<T> Function(List<T> currentList)? optimisticUpdate,
    void Function(R successData)? onSuccess,
  }) async {
    final previousState = state;

    if (optimisticUpdate != null && previousState.hasValue) {
      state = AsyncValue.data(optimisticUpdate(previousState.value!));
    }

    final result = await action();

    return result.fold(
      (failure) {
        if (previousState.hasValue) {
          state = AsyncValue.data(previousState.value!);
        }
        return Left(failure);
      },
      (successData) {
        if (onSuccess != null) {
          onSuccess(successData);
        }
        return Right(successData);
      },
    );
  }
}
