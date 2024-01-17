import 'package:bloc/bloc.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';
import '../../data/repositories/events_repo.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit({required this.eventRepo, required this.networkInfo}) : super(EventInitial());

  final EventsRepo eventRepo;
  final NetworkInfo networkInfo;

  Future<void> fetchEvents(int page, String curLocation, bool isPastEvent, String trip, String userId) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(FetchEventsError(message: "No active internet connection."));
      return;
    }

    emit(FetchEventsInProgress());
    final failureOrEventsModel = await eventRepo.fetchEvents(page, curLocation, isPastEvent, trip, userId);

    emit(failureOrEventsModel.fold((failure) {
      return FetchEventsError(message: "Something went wrong. Please try again");
    }, (eventsModel) {
      return FetchEventsSuccess(eventsModel: eventsModel);
    }));
  }
}
