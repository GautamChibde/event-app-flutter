import 'package:eventapp/model/user.dart';
import 'package:eventapp/screens/add_event/add_event.dart';
import 'package:eventapp/screens/auth/login_page.dart';
import 'package:eventapp/screens/auth/signup_page.dart';
import 'package:eventapp/screens/event/events_page.dart';
import 'package:eventapp/screens/user_edit/edit_user_profile_page.dart';
import 'package:eventapp/screens/user_profile/user_profile_page.dart';

import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginPage.kRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case EventsPage.kRoute:
        return MaterialPageRoute(builder: (_) => EventsPage());
      case AddEvent.kRoute:
        return MaterialPageRoute(builder: (_) => AddEvent());
      case SignUpPage.kRoute:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case EditUserProfilePage.kRoute:
        final User user = settings.arguments;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              EditUserProfilePage(
            user: user,
          ),
        );
      case UserProfilePage.kRoute:
        return MaterialPageRoute(builder: (_) => UserProfilePage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
