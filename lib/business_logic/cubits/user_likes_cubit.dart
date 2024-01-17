import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';
import '../../data/models/like_response_model.dart';
import '../../data/repositories/user_likes_repo.dart';

part 'user_likes_state.dart';

class UserLikesCubit extends Cubit<UserLikesState> {
  UserLikesCubit({required this.userLikesRepo, required this.networkInfo}) : super(UserLikesInitial());

  final UserLikesRepo userLikesRepo;
  final NetworkInfo networkInfo;

  Future<void> fetchUserLikes(String tripId, int page) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(FetchUserLikesError(message: "No active internet connection."));
      return;
    }

    emit(FetchUserLikesInProgress());
    final failureOrLikesResponse = await userLikesRepo.fetchLikes(tripId, page);

    emit(failureOrLikesResponse.fold((failure) {
      return FetchUserLikesError(message: "Something went wrong. Please try again");
    }, (likeResponse) {
      return FetchUserLikesSuccess(likeResponse: likeResponse);
    }));
  }
}
