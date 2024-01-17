import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../dataproviders/fetch_trip_comments_service.dart';
import '../models/comments_replies_response_model.dart';
import '../models/comments_response_model.dart';

abstract class UserCommentsRepo {
  Future<Either<Failure, CommentResponse>> fetchComments(
      String tripId, int page);

  Future<Either<Failure, CommentsRepliesResponse>> fetchCommentsReplies(
      String parentId, int page);
}

class UserCommentsRepoImpl extends UserCommentsRepo {
  FetchTripCommentsService userCommentsService;

  UserCommentsRepoImpl({required this.userCommentsService});

  @override
  Future<Either<Failure, CommentResponse>> fetchComments(
      String tripId, int page) async {
    try {
      final eventsModel = await userCommentsService.fetchComments(tripId, page);
      return right(eventsModel);
    } on FetchCommentsException {
      return left(FetchCommentsFailure());
    }
  }

  @override
  Future<Either<Failure, CommentsRepliesResponse>> fetchCommentsReplies(
      String parentId, int page) async {
    try {
      final eventsModel =
          await userCommentsService.fetchCommentsReplies(parentId, page);
      return right(eventsModel);
    } on FetchCommentsException {
      return left(FetchCommentsFailure());
    }
  }
}
