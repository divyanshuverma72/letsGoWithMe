part of 'user_comments_cubit.dart';

@immutable
abstract class UserCommentsState {
  const UserCommentsState([List props = const <dynamic>[]]) : super();
}

class UserCommentsInitial extends UserCommentsState {}

//Fetch events states
class FetchUserCommentsInProgress extends UserCommentsState {}

class FetchUserCommentsSuccess extends UserCommentsState {
  final CommentResponse commentResponse;

  FetchUserCommentsSuccess({required this.commentResponse}) :super([commentResponse]);
}

class FetchUserCommentsError extends UserCommentsState {
  final String message;

  FetchUserCommentsError({required this.message}) :super([message]);
}
