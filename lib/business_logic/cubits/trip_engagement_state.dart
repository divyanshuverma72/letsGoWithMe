part of 'trip_engagement_cubit.dart';

@immutable
abstract class TripEngagementState {
  const TripEngagementState([List props = const <dynamic>[]]) : super();
}

class TripEngagementInitial extends TripEngagementState {}

class ToggleTripLikeInProgress extends TripEngagementState {}

class ToggleTripLikeSuccess extends TripEngagementState {}

class ToggleTripLikeError extends TripEngagementState {
  final String message;

  ToggleTripLikeError({required this.message}) :super([message]);
}

class ToggleTripJoinInProgress extends TripEngagementState {}

class ToggleTripJoinSuccess extends TripEngagementState {}

class ToggleTripJoinError extends TripEngagementState {
  final String message;

  ToggleTripJoinError({required this.message}) :super([message]);
}
