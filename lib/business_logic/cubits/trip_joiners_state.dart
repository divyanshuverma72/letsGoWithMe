part of 'trip_joiners_cubit.dart';

@immutable
abstract class TripJoinersState {
  const TripJoinersState([List props = const <dynamic>[]]) : super();
}

class TripJoinersInitial extends TripJoinersState {}

//Fetch Trip Joiners states
class FetchTripJoinersInProgress extends TripJoinersState {}

class FetchTripJoinersSuccess extends TripJoinersState {
  final TripJoinersApiResponseModel tripJoinersApiResponseModel;

  FetchTripJoinersSuccess({required this.tripJoinersApiResponseModel}) :super([tripJoinersApiResponseModel]);
}

class FetchTripJoinersError extends TripJoinersState {
  final String message;

  FetchTripJoinersError({required this.message}) :super([message]);
}

