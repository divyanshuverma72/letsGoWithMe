import 'package:flutter/material.dart';
import 'package:lets_go_with_me/presentation/pages/edit_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                //Navigator.push( context, MaterialPageRoute( builder: (context) => EditProfilePage()), ).then((value) => setState(() {}));
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const EditProfilePage();
                  },
                ));
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Profile', style: TextStyle(fontSize: 18),),
                    Icon(Icons.navigate_next)
                  ],

                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences preferences = await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/", (route) => false);
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Log out', style: TextStyle(fontSize: 18),),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Privacy policy',  style: TextStyle(fontSize: 18),),
                  Icon(Icons.navigate_next)
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Terms and condition',  style: TextStyle(fontSize: 18),),
                  Icon(Icons.navigate_next)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
