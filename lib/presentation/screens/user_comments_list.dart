import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/post_comments_cubit.dart';
import 'package:lets_go_with_me/business_logic/cubits/user_comments_cubit.dart';
import 'package:lets_go_with_me/core/util/user_preferences.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import 'package:lets_go_with_me/data/repositories/post_comments_repo.dart';
import 'package:lets_go_with_me/presentation/screens/comments_widget.dart';
import '../../business_logic/cubits/user_comments_replies_cubit.dart';
import '../../core/util/locator.dart';
import '../../data/models/comments_response_model.dart';

class UserCommentsList extends StatefulWidget {
  const UserCommentsList(this.controller, this.trip, this.userId, {super.key});

  final PersistentBottomSheetController controller;
  final TripInfo trip;
  final String userId;

  @override
  State<UserCommentsList> createState() => _UserCommentsListState();
}

class _UserCommentsListState extends State<UserCommentsList>
    with AutomaticKeepAliveClientMixin {
  List<UserComment> commentsList = [];
  List<Comment> commentListReply = [];
  bool isFirstFetch = true;
  int page = 0;
  TextEditingController textEditingController = TextEditingController();

  var scrollControllerListView = ScrollController();
  FocusNode focusNode = FocusNode();
  String parentCommentId = "";
  String tripId = "";
  ValueNotifier<String> commentHint = ValueNotifier("Write a comment...");
  bool isReplyToAComment = false;
  late UserCommentsRepliesCubit userCommentsRepliesCubit;
  late BuildContext commentReplyBuildContext;
  late BlocProvider blocProvider;

  @override
  void initState() {
    super.initState();
    tripId = widget.trip.uuid;
    context.read<UserCommentsCubit>().fetchComments(widget.trip.uuid, page);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (userCommentsCubitContext) => PostCommentsCubit(
          postCommentsRepo: locator<PostCommentsRepo>(),
          networkInfo: locator()),
      child: BlocConsumer<UserCommentsCubit, UserCommentsState>(
        listener: (context, state) {
          if (state is FetchUserCommentsSuccess) {
            //commentsList = [];
            commentsList.addAll(state.commentResponse.data.comment);
            isFirstFetch = false;
          }
        },
        builder: (context, state) {
          if (state is UserCommentsInitial ||
              state is FetchUserCommentsInProgress && isFirstFetch) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchUserCommentsError) {
            return Text(state.message);
          }

          return NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              if (notification.extent < 0.9) {
                widget.controller.close();
              }
              return true;
            },
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 1,
              minChildSize: 0.5,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                scrollControllerListView = scrollController;
                return Column(
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Divider(
                          thickness: 3, height: 15, color: Colors.black),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Comments",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: commentsList.isEmpty ? const Center(child: Text("No comments")) : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollControllerListView,
                        addAutomaticKeepAlives: true,
                        itemBuilder: (context, index) {
                          if (index < commentsList.length) {
                            return CommentsWidget(
                              onPressed: (BuildContext context) {
                                commentReplyBuildContext = context;
                                isReplyToAComment = true;
                                commentHint.value =
                                    "Replying to ${commentsList[index].user.name}";
                                parentCommentId = commentsList[index].uuid;
                                tripId = commentsList[index].tripId;
                                FocusScope.of(context).requestFocus(focusNode);
                              },
                              parentCommentId: commentsList[index].uuid,
                              userName: commentsList[index].user.name,
                              userAvatar: commentsList[index].user.image,
                              comment: commentsList[index].comment,
                              commentsCount: commentsList[index].responseCount,
                              userId: commentsList[index].userId,
                              tripId: commentsList[index].tripId,
                              mobileNo: commentsList[index].user.mobileNo,
                            );
                          }
                          return null;
                        },
                        itemCount: commentsList.length,
                      ),
                    ),
                    BottomAppBar(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              height: 32,
                              width: 32,
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 40.0,
                                  child: CircleAvatar(
                                    radius: 100.0,
                                    backgroundImage:
                                    NetworkImage(UserPreferences.profileImage),
                                    backgroundColor: Colors.transparent,
                                  )),
                            ),
                            Expanded(
                              child: ValueListenableBuilder(
                                valueListenable: commentHint,
                                builder: (context, value, child) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextField(
                                      focusNode: focusNode,
                                      controller: textEditingController,
                                      decoration: InputDecoration(
                                        hintText: value,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            BlocListener<PostCommentsCubit, PostCommentsState>(
                              listener: (context, state) {
                                if (state is PostCommentsSuccess) {
                                  if (isReplyToAComment) {
                                    commentReplyBuildContext
                                        .read<UserCommentsRepliesCubit>()
                                        .addNewReplyComment(Comment(
                                            avatar: UserPreferences.profileImage,
                                            userName: UserPreferences.username,
                                            content:
                                                textEditingController.text));
                                  } else {
                                    setState(() {
                                      commentsList.insert(
                                          0,
                                          UserComment(
                                              uuid: widget.trip.uuid,
                                              userId: widget.userId,
                                              tripId: tripId,
                                              action: "comment",
                                              comment:
                                                  textEditingController.text,
                                              parentId: parentCommentId,
                                              createdTs: 4907598430,
                                              updatedTs: 4354365,
                                              responseCount: 0,
                                              user: CommentUser(
                                                  name: UserPreferences.username,
                                                  image: UserPreferences.profileImage,
                                              mobileNo: int.parse(UserPreferences.mobileNo))));
                                    }); //
                                  }
                                  textEditingController.clear();
                                }
                              },
                              child: TextButton(
                                onPressed: () {
                                  context.read<PostCommentsCubit>().postComment(
                                      isReplyToAComment,
                                      parentCommentId,
                                      widget.userId,
                                      tripId,
                                      textEditingController
                                          .text); // Clear the text field
                                },
                                child: const Text(
                                  'Send',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
