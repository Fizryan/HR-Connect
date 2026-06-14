import 'package:hr_connect/core/constants/circuit_state.dart';

class CircuitBreaker {
  CircuitState state = CircuitState.closed;

  int failureCount = 0;

  final int threshold = 5;

  DateTime? lastFailure;

  final Duration timeout = const Duration(seconds: 30);

  bool canExecute() {
    if (state == CircuitState.closed) {
      return true;
    }

    if (state == CircuitState.open) {
      if (DateTime.now().difference(lastFailure!) > timeout) {
        state = CircuitState.halfOpen;
        return true;
      }

      return false;
    }

    return true;
  }

  void onSuccess() {
    failureCount = 0;
    state = CircuitState.closed;
  }

  void onFailure() {
    failureCount++;

    lastFailure = DateTime.now();

    if (failureCount >= threshold) {
      state = CircuitState.open;
    }
  }
}
