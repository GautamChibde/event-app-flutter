import 'package:eventapp/screens/auth/login_page.dart';
import 'package:eventapp/screens/event/events_page.dart';
import 'package:eventapp/screens/user/edit_user_profile_page.dart';
import 'package:eventapp/service/auth_service.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 1),
    ).then(
      (value) => AuthService.instance.getAuthStatus().then(
        (AuthStatus status) {
          switch (status) {
            case AuthStatus.loggedIn:
              Navigator.popAndPushNamed(context, EventsPage.kRoute);
              break;
            case AuthStatus.emailNotVerified:
            case AuthStatus.loggedOut:
              Navigator.popAndPushNamed(context, LoginPage.kRoute);
              break;
            case AuthStatus.userProfileNotCreated:
              _navigateToEditProfile();
              break;
            default:
              print('default');
          }
        },
      ).catchError(
        (onError) {},
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text(
          "Event App",
          style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _navigateToEditProfile() {
    AuthService.instance
        .getCurrentUser()
        .then(
          (user) => Navigator.popAndPushNamed(
            context,
            EditUserProfilePage.kRoute,
            arguments: user,
          ),
        )
        .catchError((error) {
      print("SplashPage _navigateToEditProfile error" + error.toString());
    });
  }
}
