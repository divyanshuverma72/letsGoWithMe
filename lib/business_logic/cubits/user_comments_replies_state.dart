part of 'user_comments_replies_cubit.dart';

@immutable
abstract class UserCommentsRepliesState {
  const UserCommentsRepliesState([List props = const <dynamic>[]]) : super();
}

class UserCommentsRepliesInitial extends UserCommentsRepliesState {
}

//Fetch events states
class FetchUserCommentsRepliesInProgress extends UserCommentsRepliesState {
}

class FetchUserCommentsRepliesSuccess extends UserCommentsRepliesState {
  final CommentsRepliesResponse commentResponse;

  FetchUserCommentsRepliesSuccess({required this.commentResponse}) :super([commentResponse]);
}

class FetchUserCommentsRepliesError extends UserCommentsRepliesState {
  final String message;

  FetchUserCommentsRepliesError({required this.message}) :super([message]);
}

class NewReplyCommentAdded extends UserCommentsRepliesState {
  final Comment newComment;

  NewReplyCommentAdded({required this.newComment}) :super([newComment]);
}
