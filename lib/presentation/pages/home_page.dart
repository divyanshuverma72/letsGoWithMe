import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/core/util/locator.dart';
import 'package:lets_go_with_me/core/util/user_preferences.dart';
import 'package:lets_go_with_me/data/repositories/events_repo.dart';
import 'package:lets_go_with_me/presentation/pages/profile_page.dart';
import '../../business_logic/cubits/event_cubit.dart';
import '../screens/EventScreen.dart';
import 'create_event_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List of items in our dropdown menu
  var locations = [
    'Hyderabad',
    'Mumbai',
  ];

  String currentLocation = "Hyderabad";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 70.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: false,
                    items: locations
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: currentLocation,
                    onChanged: (String? value) {
                      setState(() {
                        currentLocation = value!;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 140,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push( context, MaterialPageRoute( builder: (context) => const ProfilePage(profilePicUrl: null, name: null, userId: null, mobileNo: null, )), ).then((value) => setState(() {
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40.0,
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundImage:
                        AssetImage(UserPreferences.profileImage.replaceAll("/home/vassar-divyanshu/AndroidStudioProjects/Personal/letsgowithme/", "")),
                        backgroundColor: Colors.transparent,
                      )),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Text("Upcoming Events"),
              ),
              Tab(child: Text("Past Events")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              color: Colors.white,
              child: BlocProvider(
                create: (context) => EventCubit(
                    eventRepo: locator<EventsRepo>(), networkInfo: locator()),
                child: EventScreen(
                  currentLocation.toLowerCase(),
                  key: UniqueKey(),
                  isPastEvent: false,
                  userId: UserPreferences.userid,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: BlocProvider(
                create: (context) => EventCubit(
                    eventRepo: locator<EventsRepo>(), networkInfo: locator()),
                child: EventScreen(
                  currentLocation.toLowerCase(),
                  key: UniqueKey(),
                  isPastEvent: true,
                  userId: UserPreferences.userid,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF1D3075),
          tooltip: 'Create a new event',
          onPressed: () {
            Navigator.push( context, MaterialPageRoute( builder: (context) => const CreateEventPage()), ).then((value) => setState(() {
            }));
            /*Navigator.pushNamed(
              context,
              '/createEvent',
            );*/
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

/*Future<void> initUserPreferences() async {
    var userIdSaved = await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.userId);
    if (!mounted) {
      return;
    }
    if (userIdSaved == null) {
      await context.read<AuthCubit>().getUserDetails(userIdSaved!);
    } else {
      await context.read<AuthCubit>().saveUserDetails();
    }
  }*/
}
