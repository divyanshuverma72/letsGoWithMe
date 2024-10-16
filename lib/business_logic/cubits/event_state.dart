part of 'event_cubit.dart';

@immutable
abstract class EventState {
  const EventState([List props = const <dynamic>[]]) : super();
}

class EventInitial extends EventState {}

//Fetch events states
class FetchEventsInProgress extends EventState {}

class FetchEventsSuccess extends EventState {
  final EventsModel eventsModel;

  FetchEventsSuccess({required this.eventsModel}) :super([eventsModel]);
}

class FetchEventsError extends EventState {
  final String message;

  FetchEventsError({required this.message}) :super([message]);
}

class DeleteEventSuccess extends EventState {
  final DeleteEventResponseModel deleteEventResponseModel;

  DeleteEventSuccess({required this.deleteEventResponseModel}) :super([deleteEventResponseModel]);
}

class DeleteEventError extends EventState {
  final String message;

  DeleteEventError({required this.message}) :super([message]);
}
