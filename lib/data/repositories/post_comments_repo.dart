import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../dataproviders/post_trip_comment_service.dart';
import '../models/post_comment_response_model.dart';

abstract class PostCommentsRepo {
  Future<Either<Failure, PostCommentsResponseModel>> postComment(
      bool isReplyToAComment,
      String parentId,
      String userId,
      String tripId,
      String comment);
}

class PostCommentsRepoImpl extends PostCommentsRepo {
  PostTripCommentService postCommentService;

  PostCommentsRepoImpl({required this.postCommentService});

  @override
  Future<Either<Failure, PostCommentsResponseModel>> postComment(
      bool isReplyToAComment,
      String parentId,
      String userId,
      String tripId,
      String comment) async {
    try {
      final postCommentsResponse = await postCommentService.postComment(
          isReplyToAComment, parentId, userId, tripId, comment);
      return right(postCommentsResponse);
    } on PostCommentsException {
      return left(PostCommentsFailure());
    }
  }
}
