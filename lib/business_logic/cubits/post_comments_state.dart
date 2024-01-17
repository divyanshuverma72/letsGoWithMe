part of 'post_comments_cubit.dart';

@immutable
abstract class PostCommentsState {
  const PostCommentsState([List props = const <dynamic>[]]) : super();
}

class PostCommentInitial extends PostCommentsState {}

class PostCommentsInProgress extends PostCommentsState {}

class PostCommentsSuccess extends PostCommentsState {}

class PostCommentsError extends PostCommentsState {
  final String message;

  PostCommentsError({required this.message}) :super([message]);
}
