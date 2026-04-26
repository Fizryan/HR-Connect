import 'package:dio/dio.dart';
import 'package:hr_connect/core/error/failures.dart';

class CoreException {
  static DioException serverFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw const NetworkFailure('Connection timeout. Please try again later');
    }
    final errorMessage = e.response?.data['message'] ?? 'An error occurred';
    throw ServerFailure(errorMessage);
  }
}
