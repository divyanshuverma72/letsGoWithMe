import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lets_go_with_me/business_logic/cubits/profile_cubit.dart';
import 'package:lets_go_with_me/business_logic/cubits/internet_cubit.dart';
import 'package:lets_go_with_me/business_logic/cubits/user_details_cubit.dart';
import 'package:lets_go_with_me/core/util/app_router.dart';
import 'package:lets_go_with_me/core/util/shared_preference_util.dart';
import 'package:lets_go_with_me/data/repositories/create_profile_repo.dart';
import 'package:lets_go_with_me/data/repositories/auth_repo.dart';
import 'package:lets_go_with_me/data/repositories/user_details_repo.dart';
import 'package:lets_go_with_me/presentation/pages/login_page.dart';
import 'package:lets_go_with_me/presentation/pages/user_details_page.dart';
import 'package:path_provider/path_provider.dart';

import 'business_logic/cubits/auth_cubit.dart';
import 'core/util/locator.dart' as di;
import 'core/util/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.setupLocator();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
  );

  final username = await SharedPreferenceUtil.instance.getStringPreferenceValue(SharedPreferenceUtil.instance.username);
  runApp(
    MyApp(isUserLoggedIn: username != null),
  );
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;
  const MyApp({super.key, required this.isUserLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (counterCubitContext) => InternetCubit(connectivity: locator()),
        ),
        BlocProvider<AuthCubit>(
          create: (counterCubitContext) => AuthCubit(authRepo: locator<AuthRepo>(), networkInfo: locator()),
        ),
        BlocProvider<ProfileCubit>(
          create: (counterCubitContext) => ProfileCubit(createProfileRepo: locator<ProfileRepo>(), networkInfo: locator()),
        ),
        BlocProvider<UserDetailsCubit>(
          create: (counterCubitContext) => UserDetailsCubit(userDetailsRepo: locator<UserDetailsRepo>(), networkInfo: locator()),
        ),
        BlocProvider<UserDetailsCubit>(
          create: (counterCubitContext) => UserDetailsCubit(userDetailsRepo: locator<UserDetailsRepo>(), networkInfo: locator()),
        ),
      ],
      child: MaterialApp(
        title: "Let's go with me",
        home: isUserLoggedIn ? const UserDetailsPage() : const LoginPage(),
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
  }
}


