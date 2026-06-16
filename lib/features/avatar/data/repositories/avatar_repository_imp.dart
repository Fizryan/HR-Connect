import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/avatar/data/remote/avatar_remote.dart';
import 'package:hr_connect/features/avatar/data/repositories/avatar_repository.dart';
import 'package:intl/intl.dart';

class AvatarRepositoryImp extends BaseRepository implements AvatarRepository {
  final AvatarRemote remoteDataSource;

  AvatarRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> uploadAvatar(File file) async {
    final apiResult = await sourceCall(() async {
      final url = await remoteDataSource.uploadAvatar(file);
      return url;
    }, Intl.message('Failed to upload avatar.', name: 'uploadAvatarFailed'));

    return apiResult.fold(
      (failure) {
        logger.e('[AvatarRepository] API call failed: ${failure.message}');
        return Left(failure);
      },
      (url) {
        return Right(url);
      },
    );
  }

  @override
  Future<Either<Failure, String>> getAvatarUrl(String filename) {
    return sourceCall(() async {
      final url = await remoteDataSource.getAvatarUrl(filename);
      return url;
    }, Intl.message('Failed to get avatar url.', name: 'getAvatarUrlFailed'));
  }
}
