import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/trip_joiners_cubit.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import 'package:lets_go_with_me/data/models/trip_joiners_api_response_model.dart';
import '../pages/profile_page.dart';
import 'likes_widget.dart';

class TripJoinersList extends StatefulWidget {
  const TripJoinersList(this.controller, this.trip, {super.key});

  final PersistentBottomSheetController controller;
  final TripInfo trip;

  @override
  State<TripJoinersList> createState() => _TripJoinersListState();
}

class _TripJoinersListState extends State<TripJoinersList>
    with AutomaticKeepAliveClientMixin {
  List<Joiners> tripJoinersList = [];
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
          context.read<TripJoinersCubit>().fetchTripJoiners(widget.trip.uuid, ++page);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userId = widget.trip.userId;
    tripId = widget.trip.uuid;
    context.read<TripJoinersCubit>().fetchTripJoiners(widget.trip.uuid, page);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<TripJoinersCubit, TripJoinersState>(
      listener: (context, state) {
        if (state is FetchTripJoinersSuccess) {
          tripJoinersList = [];
          tripJoinersList.addAll(state.tripJoinersApiResponseModel.data.joinersList);
          isFirstFetch = false;
        }
      },
      builder: (context, state) {
        if (state is TripJoinersInitial ||
            state is FetchTripJoinersInProgress && isFirstFetch) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchTripJoinersError) {
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
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.7,
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
                      "Joiners",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: tripJoinersList.isEmpty ? const Center(child: Text("No Joiners")) : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollControllerListView,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (context, index) {
                        if (index < tripJoinersList.length) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProfilePage(
                                    profilePicUrl: tripJoinersList[index].user.image,
                                    name:
                                    tripJoinersList[index].user.name,
                                    mobileNo: tripJoinersList[index].user.mobileNo.toString(),
                                    userId: tripJoinersList[index].userId,
                                  );
                                },
                              ));
                            },
                            child: LikesWidget(userName: tripJoinersList[index].user.name, userAvatar:
                            tripJoinersList[index].user.image, timeStamp: tripJoinersList[index].createdTs,),
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
                      itemCount: tripJoinersList.length,
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
