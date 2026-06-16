import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/error/failures.dart';

abstract class AvatarRepository {
  Future<Either<Failure, String>> uploadAvatar(File file);
  Future<Either<Failure, String>> getAvatarUrl(String filename);
}
