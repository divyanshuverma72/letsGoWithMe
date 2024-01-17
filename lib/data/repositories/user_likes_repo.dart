import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/data/models/like_response_model.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../dataproviders/fetch_trip_likes_service.dart';

abstract class UserLikesRepo {
  Future<Either<Failure, LikeResponse>> fetchLikes(
      String tripId, int page);
}

class UserLikesRepoImpl extends UserLikesRepo {
  FetchTripLikesService userLikesService;

  UserLikesRepoImpl({required this.userLikesService});

  @override
  Future<Either<Failure, LikeResponse>> fetchLikes(
      String tripId, int page) async {
    try {
      final eventsModel = await userLikesService.fetchLikes(tripId, page);
      return right(eventsModel);
    } on FetchCommentsException {
      return left(FetchCommentsFailure());
    }
  }
}
