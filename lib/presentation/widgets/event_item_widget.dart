import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/trip_engagement_cubit.dart';
import 'package:lets_go_with_me/core/util/user_preferences.dart';
import 'package:lets_go_with_me/data/models/events_model.dart';
import 'package:lets_go_with_me/presentation/pages/event_details_page.dart';

import '../../core/util/locator.dart';
import '../../data/repositories/trip_engagement_repo.dart';

class EventItemWidget extends StatefulWidget {
  const EventItemWidget(
      {super.key, required this.trip, required this.isPastEvent, this.onDeleteEvent});

  final TripInfo trip;
  final bool isPastEvent;
  final void Function(String tripId)? onDeleteEvent;

  @override
  State<EventItemWidget> createState() => _EventItemWidgetState();
}

class _EventItemWidgetState extends State<EventItemWidget> {
  bool postLiked = false;
  late int currentLikeCount;

  @override
  void initState() {
    super.initState();
    postLiked = widget.trip.upcomingTripActionStatus.isLiked;
    currentLikeCount = widget.trip.action.like;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (context) => TripEngagementCubit(
                        tripEngagementRepo: locator<TripEngagementRepo>(),
                        networkInfo: locator()),
                    child: EventDetailsPage(
                      UserPreferences.userid,
                      trip: widget.trip,
                      isPastEvent: widget.isPastEvent,
                    ),
                  );
                },
              ),
            ).then((value) => setState(() {}));
          },
          child: Container(
            height: 199,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(widget.trip.images[0].replaceAll("/home/vassar-divyanshu/AndroidStudioProjects/Personal/letsgowithme/", "")),
              ),
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
          ),
        ),
        widget.trip.userId == UserPreferences.userid ? Positioned(
          top: 0.1,
          right: 0.1,
          child: PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                height: 10,
                value: 0,
                child: Text("Delete"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              widget.onDeleteEvent!(widget.trip.uuid);
            }
          }),
        ): const SizedBox(),
        Positioned(
          top: 8,
          left: 8,
          child: SizedBox(
            height: 32,
            width: 32,
            child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 40.0,
                child: CircleAvatar(
                  radius: 100.0,
                  backgroundImage: AssetImage(widget.trip.user.image.replaceAll("/home/vassar-divyanshu/AndroidStudioProjects/Personal/letsgowithme/", "")),
                  backgroundColor: Colors.transparent,
                )),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.trip.title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/location.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.trip.destination,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  context
                      .read<TripEngagementCubit>()
                      .toggleLike(UserPreferences.userid, widget.trip.uuid);
                },
                child: BlocConsumer<TripEngagementCubit, TripEngagementState>(
                  listener: (context, state) {
                    if (state is ToggleTripLikeError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Something went wrong, Please try again."),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                    if (state is ToggleTripLikeSuccess) {
                      postLiked = !postLiked;
                      if (postLiked) {
                        widget.trip.upcomingTripActionStatus.isLiked = true;
                        widget.trip.action.like++;
                        currentLikeCount++;
                      } else {
                        widget.trip.upcomingTripActionStatus.isLiked = false;
                        widget.trip.action.like--;
                        currentLikeCount--;
                      }
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 22,
                        width: 50,
                        decoration: BoxDecoration(
                          color: postLiked ? Colors.red : Colors.black,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset("assets/images/white_heart.png"),
                            Text(
                              currentLikeCount.toString(),
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  },
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    color: widget.trip.upcomingTripActionStatus.isJoined
                        ? Colors.orange
                        : Colors.black,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      ]),
    );
  }
}
