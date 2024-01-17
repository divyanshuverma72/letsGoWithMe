import 'package:bloc/bloc.dart';
import 'package:lets_go_with_me/data/models/trip_joiners_api_response_model.dart';
import 'package:lets_go_with_me/data/repositories/trip_joiners_repo.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';

part 'trip_joiners_state.dart';

class TripJoinersCubit extends Cubit<TripJoinersState> {
  TripJoinersCubit({required this.tripJoinersRepo, required this.networkInfo}) : super(TripJoinersInitial());

  final TripJoinersRepo tripJoinersRepo;
  final NetworkInfo networkInfo;

  Future<void> fetchTripJoiners(String tripId, int page) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(FetchTripJoinersError(message: "No active internet connection."));
      return;
    }

    emit(FetchTripJoinersInProgress());
    final tripJoinersResponse = await tripJoinersRepo.fetchTripJoinersList(tripId, page);

    emit(tripJoinersResponse.fold((failure) {
      return FetchTripJoinersError(message: "Something went wrong. Please try again");
    }, (tripJoiners) {
      return FetchTripJoinersSuccess(tripJoinersApiResponseModel: tripJoiners);
    }));
  }
}

