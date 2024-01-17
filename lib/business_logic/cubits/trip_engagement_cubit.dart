import 'package:bloc/bloc.dart';
import 'package:lets_go_with_me/data/repositories/trip_engagement_repo.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';

part 'trip_engagement_state.dart';

class TripEngagementCubit extends Cubit<TripEngagementState> {
  TripEngagementCubit({required this.tripEngagementRepo, required this.networkInfo}) : super(TripEngagementInitial());

  final TripEngagementRepo tripEngagementRepo;
  final NetworkInfo networkInfo;

  Future<void> toggleLike(String userId, String tripId) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(ToggleTripLikeError(message: "No active internet connection."));
      return;
    }

    emit(ToggleTripLikeInProgress());
    final toggleTripResponse = await tripEngagementRepo.toggleLike(userId, tripId);

    emit(toggleTripResponse.fold((failure) {
      return ToggleTripLikeError(message: "Something went wrong. Please try again");
    }, (commentResponse) {
      return ToggleTripLikeSuccess();
    }));
  }

  Future<void> toggleJoin(String userId, String tripId) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(ToggleTripJoinError(message: "No active internet connection."));
      return;
    }

    emit(ToggleTripJoinInProgress());
    final toggleTripResponse = await tripEngagementRepo.toggleJoin(userId, tripId);

    emit(toggleTripResponse.fold((failure) {
      return ToggleTripJoinError(message: "Something went wrong. Please try again");
    }, (commentResponse) {
      return ToggleTripJoinSuccess();
    }));
  }
}

