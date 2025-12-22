import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  final _connectivityController = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityController.stream;

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _isOnline = false;
    } on TimeoutException catch (_) {
      _isOnline = false;
    } catch (_) {
      _isOnline = false;
    }
    _connectivityController.add(_isOnline);
    return _isOnline;
  }

  void dispose() {
    _connectivityController.close();
  }
}

mixin OfflineCapable {
  bool _isOffline = false;
  bool get isOffline => _isOffline;

  void setOfflineStatus(bool status) {
    _isOffline = status;
  }

  Future<T> executeWithOfflineFallback<T>({
    required Future<T> Function() onlineAction,
    required T Function() offlineAction,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final isOnline = await ConnectivityService().checkConnectivity();
      if (!isOnline) {
        _isOffline = true;
        return offlineAction();
      }

      final result = await onlineAction().timeout(timeout);
      _isOffline = false;
      return result;
    } on TimeoutException {
      _isOffline = true;
      return offlineAction();
    } on SocketException {
      _isOffline = true;
      return offlineAction();
    } catch (e) {
      debugPrint('Error in executeWithOfflineFallback: $e');
      rethrow;
    }
  }
}

class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final VoidCallback? onRetry;

  const OfflineBanner({super.key, required this.isOffline, this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange.shade700,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'You\'re offline. Showing cached data.',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
