import 'package:bloc/bloc.dart';
import 'package:lets_go_with_me/data/models/comments_response_model.dart';
import 'package:lets_go_with_me/data/repositories/user_comments_repo.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';

part 'user_comments_state.dart';

class UserCommentsCubit extends Cubit<UserCommentsState> {

  UserCommentsCubit({required this.userCommentsRepo, required this.networkInfo}) : super(UserCommentsInitial());

  final UserCommentsRepo userCommentsRepo;
  final NetworkInfo networkInfo;

  Future<void> fetchComments(String tripId, int page) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(FetchUserCommentsError(message: "No active internet connection."));
      return;
    }

    emit(FetchUserCommentsInProgress());
    final failureOrCommentsResponse = await userCommentsRepo.fetchComments(tripId, page);

    emit(failureOrCommentsResponse.fold((failure) {
      return FetchUserCommentsError(message: "Something went wrong. Please try again");
    }, (commentResponse) {
      return FetchUserCommentsSuccess(commentResponse: commentResponse);
    }));
  }
}
