import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/user_likes_cubit.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import 'package:lets_go_with_me/data/models/like_response_model.dart';
import '../pages/profile_page.dart';
import 'likes_widget.dart';

class UserLikesList extends StatefulWidget {
  const UserLikesList(this.controller, this.trip, {super.key});

  final PersistentBottomSheetController controller;
  final TripInfo trip;

  @override
  State<UserLikesList> createState() => _UserLikesListState();
}

class _UserLikesListState extends State<UserLikesList>
    with AutomaticKeepAliveClientMixin {
  List<Like> userLikesList = [];
  bool isFirstFetch = true;
  int page = 0;

  var scrollControllerListView = ScrollController();
  String parentCommentId = "";
  String userId = "";
  String tripId = "";

  void setupScrollController(context) {
    scrollControllerListView.addListener(() {
      if (scrollControllerListView.position.atEdge) {
        if (scrollControllerListView.position.pixels != 0) {
          context.read<UserLikesCubit>().fetchUserLikes(widget.trip.uuid, ++page);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userId = widget.trip.userId;
    tripId = widget.trip.uuid;
    context.read<UserLikesCubit>().fetchUserLikes(widget.trip.uuid, page);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<UserLikesCubit, UserLikesState>(
      listener: (context, state) {
        if (state is FetchUserLikesSuccess) {
          userLikesList = [];
          userLikesList.addAll(state.likeResponse.data.likeList);
          isFirstFetch = false;
        }
      },
      builder: (context, state) {
        if (state is UserLikesInitial ||
            state is FetchUserLikesInProgress && isFirstFetch) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchUserLikesError) {
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
              setupScrollController(context);
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
                      "Likes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: userLikesList.isEmpty ? const Center(child: Text("No Likes")) : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollControllerListView,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (context, index) {
                        if (index < userLikesList.length) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProfilePage(
                                    profilePicUrl: userLikesList[index].user.image,
                                    name:
                                    userLikesList[index].user.name,
                                    mobileNo: userLikesList[index].user.mobileNo.toString(),
                                    userId: userLikesList[index].userId,
                                  );
                                },
                              ));
                            },
                            child: LikesWidget(userName: userLikesList[index].user.name, userAvatar:
                            userLikesList[index].user.image, timeStamp: userLikesList[index].createdTs,),
                          );
                        } else {
                          if (!isFirstFetch) {
                            Timer(const Duration(milliseconds: 30), () {
                              if (scrollControllerListView.hasClients) {
                                scrollControllerListView.jumpTo(
                                    scrollControllerListView
                                        .position.maxScrollExtent);
                              }
                            });

                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }
                        return null;
                      },
                      itemCount: userLikesList.length,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
