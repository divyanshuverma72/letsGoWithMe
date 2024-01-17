part of 'create_event_cubit.dart';

@immutable
abstract class CreateEventState {
  const CreateEventState([List props = const <dynamic>[]]) : super();
}

//Create profile states
class CreateEventInitial extends CreateEventState {}

class UploadEventProfilePicInProgress extends CreateEventState {}

class UploadEventProfilePicSuccess extends CreateEventState {
  final String profilePicUrl;

  UploadEventProfilePicSuccess({required this.profilePicUrl}) :super([profilePicUrl]);
}

class UploadEventProfilePicError extends CreateEventState {
  final String message;

  UploadEventProfilePicError({required this.message}) :super([message]);
}

class SaveEventDetailsInProgress extends CreateEventState {}

class SaveEventDetailsSuccess extends CreateEventState {
  final String status;

  SaveEventDetailsSuccess({required this.status}) :super([status]);
}

class SaveEventDetailsError extends CreateEventState {
  final String message;

  SaveEventDetailsError({required this.message}) :super([message]);
}