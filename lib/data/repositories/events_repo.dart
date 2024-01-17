import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/core/error/exceptions.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import '../../core/error/failures.dart';
import '../dataproviders/events_service.dart';

abstract class EventsRepo {
  Future<Either<Failure, EventsModel>> fetchEvents(int page, String curLocation, bool isPastEvent, String trip, String userId);
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
}
