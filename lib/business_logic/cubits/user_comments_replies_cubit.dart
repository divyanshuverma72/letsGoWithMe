import 'package:bloc/bloc.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:flutter/cupertino.dart';

import '../../core/util/network_Info.dart';
import '../../data/models/comments_replies_response_model.dart';
import '../../data/repositories/user_comments_repo.dart';

part 'user_comments_replies_state.dart';

class UserCommentsRepliesCubit extends Cubit<UserCommentsRepliesState> {

  UserCommentsRepliesCubit(this.buildContext, {required this.userCommentsRepo, required this.networkInfo}) : super(UserCommentsRepliesInitial());

  final UserCommentsRepo userCommentsRepo;
  final NetworkInfo networkInfo;
  final BuildContext buildContext;

  Future<void> fetchCommentsReplies(String parentId, int page) async {

    final internetAvailable = await networkInfo.isConnected;
    if (!internetAvailable) {
      emit(FetchUserCommentsRepliesError(message: "No active internet connection."));
      return;
    }

    emit(FetchUserCommentsRepliesInProgress());
    final failureOrCommentsResponse = await userCommentsRepo.fetchCommentsReplies(parentId, page);

    emit(failureOrCommentsResponse.fold((failure) {
      return FetchUserCommentsRepliesError(message: "Something went wrong. Please try again");
    }, (commentResponse) {
      return FetchUserCommentsRepliesSuccess(commentResponse: commentResponse);
    }));
  }

  void addNewReplyComment(Comment comment) {
    emit(NewReplyCommentAdded(newComment: comment));
  }
}
