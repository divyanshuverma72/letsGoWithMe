part of 'user_likes_cubit.dart';

@immutable
abstract class UserLikesState {
  const UserLikesState([List props = const <dynamic>[]]) : super();
}

class UserLikesInitial extends UserLikesState {}

//Fetch likes states
class FetchUserLikesInProgress extends UserLikesState {}

class FetchUserLikesSuccess extends UserLikesState {
  final LikeResponse likeResponse;

  FetchUserLikesSuccess({required this.likeResponse}) :super([likeResponse]);
}

class FetchUserLikesError extends UserLikesState {
  final String message;

  FetchUserLikesError({required this.message}) :super([message]);
}
