import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/failures.dart';

class CoreException {
  static Never handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkFailure('Connection timeout. Please try again later');
    }

    final errorMessage = e.response?.data is Map<String, dynamic>
        ? e.response?.data['message']
        : 'An error occurred';

    throw ServerFailure(errorMessage ?? 'An error occurred');
  }
}
