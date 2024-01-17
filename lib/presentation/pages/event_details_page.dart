import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lets_go_with_me/business_logic/cubits/trip_joiners_cubit.dart';
import 'package:lets_go_with_me/core/constants/widget_constants.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import 'package:lets_go_with_me/data/repositories/trip_joiners_repo.dart';
import 'package:lets_go_with_me/data/repositories/user_likes_repo.dart';
import 'package:lets_go_with_me/presentation/screens/trip_joiners_list.dart';
import 'package:lets_go_with_me/presentation/screens/user_comments_list.dart';
import 'package:lets_go_with_me/presentation/screens/user_likes_list.dart';

import '../../business_logic/cubits/trip_engagement_cubit.dart';
import '../../business_logic/cubits/user_comments_cubit.dart';
import '../../business_logic/cubits/user_likes_cubit.dart';
import '../../core/util/locator.dart';
import '../../data/repositories/user_comments_repo.dart';
import '../reusable_widgets/filled_card_text_button.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage(this.userId,
      {super.key, required this.trip, required this.isPastEvent});

  final TripInfo trip;
  final bool isPastEvent;
  final String userId;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late int dobInMillis;

  var isLoading = false;
  File imageFile = File("");
  String profilePicUrl = "";
  late PersistentBottomSheetController _controller;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool canPop) {
      },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(bgColor),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Row(
              children: [
                SizedBox(
                  height: 48,
                  width: 48,
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: NetworkImage(widget.trip.user.image),
                    backgroundColor: Colors.transparent,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.trip.user.name,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: BlocConsumer<TripEngagementCubit, TripEngagementState>(
                    listener: (context, state) {
                      if (state is ToggleTripJoinError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Something went wrong, Please try again."),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                      if (state is ToggleTripJoinSuccess) {
                        widget.trip.action.joined++;
                        widget.trip.upcomingTripActionStatus.isJoined = true;
                      }
                    },
                    builder: (context, state) {
                      return Stack(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          //form
                          child: Container(
                            height: 199,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.trip.images[0]),
                              ),
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          right: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 22,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        widget.trip.upcomingTripActionStatus.isLiked
                                            ? Colors.red
                                            : Colors.black,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset("assets/images/white_heart.png"),
                                      Text(
                                        widget.trip.action.like.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 22,
                                  width: 47,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset("assets/images/comment.png"),
                                      Text(
                                        widget.trip.action.comment.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 22,
                                  width: 47,
                                  decoration: BoxDecoration(
                                    color: widget
                                            .trip.upcomingTripActionStatus.isJoined
                                        ? Colors.orange
                                        : Colors.black,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset("assets/images/join.png"),
                                      Text(
                                        widget.trip.action.joined.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: 140,
                            left: 16,
                            right: 16,
                            child: Container(
                                width: double.infinity,
                                //color: Colors.blueAccent, if you use box decoration we use color inside that boxDecoration, otherwise it results in error
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(widget.trip.title,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Text(widget.trip.description,
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 14)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0, top: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              widget.trip.destination,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              DateFormat()
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          widget.trip.startDate))
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16, top: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (!widget.trip.upcomingTripActionStatus
                                              .isJoined) {
                                            context
                                                .read<TripEngagementCubit>()
                                                .toggleJoin(widget.userId,
                                                    widget.trip.uuid);
                                          }
                                        },
                                        child: !widget.isPastEvent
                                            ? FilledCardTextButton(
                                                backgroundColor: !widget
                                                        .trip
                                                        .upcomingTripActionStatus
                                                        .isJoined
                                                    ? Colors.red
                                                    : Colors.grey,
                                                title: widget
                                                        .trip
                                                        .upcomingTripActionStatus
                                                        .isJoined
                                                    ? "Joined"
                                                    : "Join Trip",
                                                buttonHeight: 48,
                                                buttonWidth: 326,
                                                fontSize: 16,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ],
                                )))
                      ]);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _controller =
                            scaffoldKey.currentState!.showBottomSheet((context) {
                          return BlocProvider(
                            create: (userCommentsCubitContext) => UserCommentsCubit(
                                userCommentsRepo: locator<UserCommentsRepo>(),
                                networkInfo: locator()),
                            child: UserCommentsList(
                                _controller, widget.trip, widget.userId),
                          );
                        });
                      },
                      child: const FilledCardTextButton(
                        backgroundColor: Color(0xFF1D3075),
                        title: "Comments",
                        buttonHeight: 48,
                        buttonWidth: 120,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _controller =
                            scaffoldKey.currentState!.showBottomSheet((context) {
                          return BlocProvider(
                            create: (userLikesCubitContext) => UserLikesCubit(
                                userLikesRepo: locator<UserLikesRepo>(),
                                networkInfo: locator()),
                            child: UserLikesList(_controller, widget.trip),
                          );
                        });
                      },
                      child: const FilledCardTextButton(
                        backgroundColor: Color(0xFF1D3075),
                        title: "Likes",
                        buttonHeight: 48,
                        buttonWidth: 120,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _controller =
                            scaffoldKey.currentState!.showBottomSheet((context) {
                              return BlocProvider(
                                create: (userLikesCubitContext) => TripJoinersCubit(
                                    tripJoinersRepo: locator<TripJoinersRepo>(),
                                    networkInfo: locator()),
                                child: TripJoinersList(_controller, widget.trip),
                              );
                            });
                      },
                      child: const FilledCardTextButton(
                        backgroundColor: Color(0xFF1D3075),
                        title: "Joiners",
                        buttonHeight: 48,
                        buttonWidth: 120,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class EventDetailsPageArguments {
  final TripInfo upcomingTrip;

  EventDetailsPageArguments({required this.upcomingTrip});
}
