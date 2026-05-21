import 'package:dio/dio.dart';

class CoreException {
  static ServerException handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return ServerException(message: 'Connection timeout. Please check your internet and try again.');
    }

    if (e.type == DioExceptionType.cancel) {
      return ServerException(message: 'Request canceled.');
    }

    String errorMessage = 'An error occurred';

    if (e.response?.data != null && e.response?.data is Map<String, dynamic>) { 
      final data = e.response?.data as Map<String, dynamic>;
      errorMessage = data['message'] as String? ?? errorMessage;
    }
    
    return ServerException(message: errorMessage);
  }
}

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});

  @override
  String toString() => message;
}
