import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import '../../core/error/failures.dart';
import '../dataproviders/events_service.dart';
import '../models/delete_event_response_model.dart';

abstract class EventsRepo {
  Future<Either<Failure, EventsModel>> fetchEvents(int page, String curLocation, bool isPastEvent, String trip, String userId);
  Future<Either<Failure, DeleteEventResponseModel>> deleteEvent(String tripId);
}

class EventRepoImpl extends EventsRepo {
  EventsService eventsService;

  EventRepoImpl({required this.eventsService});

  @override
  Future<Either<Failure, EventsModel>> fetchEvents(int page, String curLocation, bool isPastEvent, String trip, String userId) async {
    try {
      final eventsModel = await eventsService.fetchEvents(page, curLocation, isPastEvent, trip, userId);
      return right(eventsModel);
    } on EventsException {
      return left(FetchEventsFailure());
    }
  }

  @override
  Future<Either<Failure, DeleteEventResponseModel>> deleteEvent(String tripId) async {
    try {
      final deleteEventResponseModel = await eventsService.deleteEvent(tripId);
      return right(deleteEventResponseModel);
    } on DeleteEventException {
      return left(DeleteEventFailure());
    }
  }
}
