import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/event_cubit.dart';
import '../../business_logic/cubits/trip_engagement_cubit.dart';
import '../../core/util/locator.dart';
import '../../data/models/events_model.dart';
import '../../data/repositories/trip_engagement_repo.dart';
import '../widgets/event_item_widget.dart';

class EventScreen extends StatefulWidget {
  const EventScreen(this.curLocation, {super.key, required this.isPastEvent, this.trip = "", required this.userId});

  final String curLocation;
  final bool isPastEvent;
  final String trip;
  final String userId;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with AutomaticKeepAliveClientMixin {
  List<TripInfo> tripList = [];
  bool isFirstFetch = true;
  int page = 0;
  bool isLoading = true;
  late EventCubit eventCubit;

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          if (!isLoading) {
            return;
          }
          eventCubit.fetchEvents(++page, widget.curLocation, widget.isPastEvent, widget.trip, widget.userId);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setupScrollController(context);
    tripList = [];
    eventCubit = BlocProvider.of<EventCubit>(context);
    eventCubit.fetchEvents(page, widget.curLocation, widget.isPastEvent, widget.trip, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<EventCubit, EventState>(
      listener: (context, state) {
        if (state is FetchEventsSuccess) {
          tripList.addAll(state.eventsModel.data.upcomingTrip);
          isFirstFetch = false;
          if (state.eventsModel.offset == 0) {
            isLoading = false;
          }
        }
      },
      builder: (context, state) {
        if (state is FetchEventsSuccess) {
          if (tripList.isEmpty) {
            return const Center(child: Text("No Events"));
          }
        }

        if (state is EventInitial ||
            state is FetchEventsInProgress && isFirstFetch) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchEventsError) {
          return Center(child: Text(state.message));
        }

        return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 1500));
              if (!mounted) {
                return;
              }
              page = 0;
              tripList = [];
              isLoading = true;
              eventCubit.fetchEvents(page, widget.curLocation, widget.isPastEvent, widget.trip, widget.userId);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index < tripList.length) {
                  return BlocProvider(
                    create: (tripEngagementContext) => TripEngagementCubit(
                        tripEngagementRepo: locator<TripEngagementRepo>(),
                        networkInfo: locator()),
                    child: EventItemWidget(
                      trip: tripList[index], isPastEvent: widget.isPastEvent
                    ),
                  );
                } else {
                  if (!isFirstFetch) {
                    Timer(const Duration(milliseconds: 30), () {
                      if (scrollController.hasClients) {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                      }
                    });

                    return const Center(
                        child: Center(child: CircularProgressIndicator()));
                  }
                }
                return null;
              },
              itemCount: tripList.length + (isLoading ? 1 : 0),
            ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
