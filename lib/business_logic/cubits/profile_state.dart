part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {
  const ProfileState([List props = const <dynamic>[]]) : super();
}

//Create profile states
class CreateProfileInitial extends ProfileState {}

class UploadProfilePicInProgress extends ProfileState {}

class UploadProfilePicSuccess extends ProfileState {
  final String profilePicUrl;

  UploadProfilePicSuccess({required this.profilePicUrl}) :super([profilePicUrl]);
}

class UploadProfilePicError extends ProfileState {
  final String message;

  UploadProfilePicError({required this.message}) :super([message]);
}

//Save profile states
class SaveProfileDetailsInProgress extends ProfileState {}

class SaveProfileDetailsSuccess extends ProfileState {
  final String status;

  SaveProfileDetailsSuccess({required this.status}) :super([status]);
}

class SaveProfileDetailsError extends ProfileState {
  final String message;

  SaveProfileDetailsError({required this.message}) :super([message]);
}

//Username verification states
class UserNameVerificationInProgress extends ProfileState {}

class UserNameVerificationSuccess extends ProfileState {
  final bool usernameExists;
  final String username;

  UserNameVerificationSuccess({required this.usernameExists, required this.username}) :super([usernameExists, username]);
}

class UserNameVerificationError extends ProfileState {
  final String message;

  UserNameVerificationError({required this.message}) :super([message]);
}