import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/user_details_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {

  @override
  void initState() {
    super.initState();
    context.read<UserDetailsCubit>().fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDetailsCubit, UserDetailsState>(
      listener: (context, state) async {
        if (state is GetUserDetailsFailure) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          if (!mounted) {
            return;
          }
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/", (route) => false);
        }
        if (state is GetUserDetailsSuccess) {
          Navigator.of(context)
                          .pushNamedAndRemoveUntil("/home", (route) => false);
        }
      },
      builder: (context, state) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
      },
    );
  }
}
