import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/failures.dart';

class CoreException {
  static Never handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkFailure('Connection timeout. Please try again later');
    }

    if (e.type == DioExceptionType.cancel) {
      throw ServerException(message: 'Request canceled.');
    }

    String errorMessage = 'An error occurred';

    if (e.response?.data != null && e.response?.data is Map<String, dynamic>) { 
      errorMessage = e.response?.data['message'] ?? errorMessage;
    }
    
    throw ServerException(message: errorMessage);
  }
}

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}
