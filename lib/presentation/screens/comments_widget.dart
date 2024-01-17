// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/data/models/comments_replies_response_model.dart';
import '../../business_logic/cubits/user_comments_replies_cubit.dart';
import '../../core/util/locator.dart';
import '../../data/repositories/user_comments_repo.dart';
import '../pages/profile_page.dart';

class CommentsWidget extends StatefulWidget {
  CommentsWidget(
      {super.key,
      required this.onPressed,
      required this.parentCommentId,
      required this.userName,
      required this.userAvatar,
      required this.comment,
      required this.commentsCount,
      required this.userId,
      required this.tripId,
      required this.mobileNo});

  final String parentCommentId;
  final String userName;
  final String userAvatar;
  final String comment;
  final int commentsCount;
  final void Function(BuildContext context) onPressed;
  final String userId;
  final String tripId;
  final int mobileNo;

  List<Comment> commentList = [];

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget>
    with AutomaticKeepAliveClientMixin {
  bool showViewRepliesButton = true;
  TextEditingController textEditingController = TextEditingController();
  late UserCommentsRepliesCubit userCommentsRepliesCubit;

  @override
  void initState() {
    super.initState();
    userCommentsRepliesCubit = UserCommentsRepliesCubit(context,
        userCommentsRepo: locator<UserCommentsRepo>(), networkInfo: locator());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => userCommentsRepliesCubit,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: BlocConsumer<UserCommentsRepliesCubit, UserCommentsRepliesState>(
          listener: (context, state) {
            if (state is NewReplyCommentAdded) {
              widget.commentList.add(state.newComment);
            }
            if (state is FetchUserCommentsRepliesSuccess) {
              showViewRepliesButton = false;
              for (UserCommentReplies userComment
                  in state.commentResponse.data.comment) {
                widget.commentList.add(Comment(
                    avatar: userComment.user.image,
                    userName: userComment.user.name,
                    content: userComment.comment));
              }
            }
          },
          builder: (context, state) {
            return CommentTreeWidget<Comment, Comment>(
              Comment(
                  avatar: widget.userAvatar,
                  userName: widget.userName,
                  content: widget.comment),
              widget.commentList,
              treeThemeData: const TreeThemeData(
                  lineColor: Colors.transparent, lineWidth: 3),
              avatarRoot: (context, data) => PreferredSize(
                preferredSize: const Size.fromRadius(18),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProfilePage(
                          profilePicUrl: widget.userAvatar,
                          name: widget.userName,
                          mobileNo: widget.mobileNo.toString(),
                          userId: widget.userId,
                        );
                      },
                    ));
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                      data.avatar!,
                    ),
                  ),
                ),
              ),
              avatarChild: (context, data) => PreferredSize(
                preferredSize: const Size.fromRadius(12),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(data.avatar!),
                ),
              ),
              contentChild: (context, data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.userName!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${data.content}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              contentRoot: (context, data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ProfilePage(
                                profilePicUrl: widget.userAvatar,
                                name: widget.userName,
                                mobileNo: widget.mobileNo.toString(),
                                userId: widget.userId,
                              );
                            },
                          ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.userName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${data.content}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            BlocProvider<UserCommentsRepliesCubit>.value(
                              value: userCommentsRepliesCubit,
                              child: TextButton(
                                  onPressed: () {
                                    widget.onPressed(context);
                                  },
                                  child: const Text('Reply')),
                            ),
                            widget.commentsCount > 0 && showViewRepliesButton
                                ? TextButton(
                                    onPressed: () {
                                      BlocProvider.of<UserCommentsRepliesCubit>(
                                              context)
                                          .fetchCommentsReplies(
                                              widget.parentCommentId, 0);
                                    },
                                    child: Text(
                                      "View ${widget.commentsCount} replies",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))
                                : const SizedBox()
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
