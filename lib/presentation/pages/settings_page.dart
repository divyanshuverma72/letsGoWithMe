import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/delete_account_cubit.dart';
import 'package:lets_go_with_me/core/constants/api_constants.dart';
import 'package:lets_go_with_me/data/repositories/delete_account_repo.dart';
import 'package:lets_go_with_me/presentation/pages/edit_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/util/locator.dart';
import '../../core/util/user_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/", (route) => false);
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Log out',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(privacyPolicyUrl);
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Privacy policy',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse(tncUrl);
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terms and conditions',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                showAlertDialog(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete account',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget yesButton = BlocProvider(
      create: (context) => DeleteAccountCubit(
          networkInfo: locator(),
          deleteAccountRepo: locator<DeleteAccountRepo>()),
      child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) async {
          if (state is DeleteAccountSuccess) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.clear();
            Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
          }

          if (state is DeleteAccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "Could not delete account, Please try again."),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DeleteAccountInProgress) {
            return const CircularProgressIndicator();
          }
          return TextButton(
            child: const Text("Yes"),
            onPressed: () async {
              DeleteAccountCubit deleteAccountCubit =
                  BlocProvider.of<DeleteAccountCubit>(context);
              deleteAccountCubit.deleteUserAccount(UserPreferences.userid);
            },
          );
        },
      ),
    );
    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: const Text("Are you sure, you want to delete your account?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
