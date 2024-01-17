part of 'user_details_cubit.dart';

@immutable
abstract class UserDetailsState {
  const UserDetailsState([List props = const <dynamic>[]]) : super();
}

class UserDetailsInitial extends UserDetailsState {}

class GetUserDetailsFailure extends UserDetailsState {

}

class GetUserDetailsSuccess extends UserDetailsState {

}

class UserDetailsError extends UserDetailsState {
  final String message;
  UserDetailsError({required this.message}) :super([message]);
}
