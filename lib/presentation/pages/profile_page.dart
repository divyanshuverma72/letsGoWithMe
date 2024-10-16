import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/presentation/pages/settings_page.dart';

import '../../business_logic/cubits/event_cubit.dart';
import '../../core/util/locator.dart';
import '../../core/util/user_preferences.dart';
import '../../data/repositories/events_repo.dart';
import '../screens/EventScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profilePicUrl, required this.name, required this.mobileNo, required this.userId});
  final String? profilePicUrl;
  final String? name;
  final String? mobileNo;
  final String? userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push( context, MaterialPageRoute( builder: (context) => const SettingsPage()), ).then((value) => setState(() {
              }));
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundImage: NetworkImage(widget.profilePicUrl ?? UserPreferences.profileImage),
                      backgroundColor: Colors.transparent,
                    )
                  ),
                  const SizedBox(width: 17),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name ??
                        "${UserPreferences.firstName} ${UserPreferences.lastName}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0.06,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone, size: 15,),
                          const SizedBox(width: 9),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              widget.mobileNo ??
                              UserPreferences.mobileNo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF525252),
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                height: 0.11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // TabBarView with respective tab contents
          Expanded(
            child: DefaultTabController(
              length: 3, // Number of tabs
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.blueAccent,
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        child: Text("Upcoming"),
                      ),
                      Tab(child: Text("Joined")),
                      Tab(child: Text("Past")),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          color: Colors.white,
                          child: BlocProvider(
                            create: (context) => EventCubit(
                                eventRepo: locator<EventsRepo>(), networkInfo: locator()),
                            child: EventScreen(
                              "",
                              key: UniqueKey(),
                              isPastEvent: false,
                              trip: "upcoming",
                              userId: widget.userId ?? UserPreferences.userid,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: BlocProvider(
                            create: (context) => EventCubit(
                                eventRepo: locator<EventsRepo>(), networkInfo: locator()),
                            child: EventScreen(
                              "",
                              key: UniqueKey(),
                              isPastEvent: false,
                              trip: "join",
                              userId: widget.userId ?? UserPreferences.userid,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: BlocProvider(
                            create: (context) => EventCubit(
                                eventRepo: locator<EventsRepo>(), networkInfo: locator()),
                            child: EventScreen(
                              "",
                              key: UniqueKey(),
                              isPastEvent: true,
                              trip: "past",
                              userId: widget.userId ?? UserPreferences.userid,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
