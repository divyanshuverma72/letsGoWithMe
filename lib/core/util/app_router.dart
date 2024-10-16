import 'package:flutter/material.dart';
import 'package:lets_go_with_me/presentation/pages/create_event_page.dart';
import '../../presentation/pages/create_profile_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/login_page.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) =>
          const LoginPage(
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) =>
              const HomePage(),
        );

      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const CreateProfilePage(),
        );

      case '/createEvent':
        return MaterialPageRoute(
          builder: (_) => const CreateEventPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
          const LoginPage(
          ),
        );
    }
  }
}
