import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/dataproviders/trip_engagement_service.dart';
import '../../core/error/failures.dart';

abstract class TripEngagementRepo {
  Future<Either<Failure, String>> toggleLike(String userId, String tripId);

  Future<Either<Failure, String>> toggleJoin(String userId, String tripId);
}

class TripEngagementRepoImpl extends TripEngagementRepo {
  TripEngagementService tripEngagementService;

  TripEngagementRepoImpl({required this.tripEngagementService});

  @override
  Future<Either<Failure, String>> toggleLike(
      String userId, String tripId) async {
    try {
      final toggleLikeResponseModel =
          await tripEngagementService.toggleLike(userId, tripId);
      return right(toggleLikeResponseModel.message);
    } on TripEngagementException {
      return left(TripEngagementFailure());
    }
  }

  @override
  Future<Either<Failure, String>> toggleJoin(
      String userId, String tripId) async {
    try {
      final toggleJoinResponseModel =
          await tripEngagementService.toggleJoin(userId, tripId);
      return right(toggleJoinResponseModel.message);
    } on TripEngagementException {
      return left(TripEngagementFailure());
    }
  }
}
