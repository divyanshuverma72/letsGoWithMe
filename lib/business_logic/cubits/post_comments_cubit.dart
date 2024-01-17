import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/util/network_Info.dart';
import '../../data/repositories/post_comments_repo.dart';

part 'post_comments_state.dart';

class PostCommentsCubit extends Cubit<PostCommentsState> {
  PostCommentsCubit({required this.postCommentsRepo, required this.networkInfo})
      : super(PostCommentInitial());

  final PostCommentsRepo postCommentsRepo;
  final NetworkInfo networkInfo;

  Future<void> postComment(bool isReplyToAComment, String parentId,
      String userId, String tripId, String comment) async {
    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(PostCommentsError(message: "No active internet connection."));
      return;
    }

    emit(PostCommentsInProgress());
    final failureOrPostCommentsResponse = await postCommentsRepo.postComment(
        isReplyToAComment, parentId, userId, tripId, comment);

    emit(failureOrPostCommentsResponse.fold((failure) {
      return PostCommentsError(
          message: "Something went wrong. Please try again");
    }, (commentResponse) {
      return PostCommentsSuccess();
    }));
  }
}
