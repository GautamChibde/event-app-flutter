import 'package:eventapp/model/user.dart';
import 'package:eventapp/screens/user_edit/edit_user_profile_page.dart';
import 'package:eventapp/screens/user_profile/user_profile_bloc.dart';
import 'package:eventapp/service/auth_service.dart';
import 'package:eventapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  static const kRoute = "/userProfilePage";
  UserProfilePage({Key key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserProfileBloc _userProfileBloc;

  @override
  void initState() {
    _userProfileBloc = UserProfileBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _userProfileBloc.user,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          final user = snapshot.data;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _profileImage(user.imageUrl),
                  SizedBox(height: 12),
                  _userName(user),
                  SizedBox(height: 4),
                  _userEmail(user),
                  SizedBox(height: 12),
                  _bioLabel(),
                  SizedBox(height: 12),
                  _bio(user),
                  SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      _editProfileButton(context, user),
                      SizedBox(width: 8),
                      Expanded(child: _logoutButton())
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  RaisedButton _logoutButton() {
    return RaisedButton(
      child: Text(
        "Logout",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: Colors.red,
      onPressed: () {
        AuthService.instance.signOut();
      },
    );
  }

  Expanded _editProfileButton(BuildContext context, User user) {
    return Expanded(
      child: OutlineButton(
        child: Text("Edit Profile"),
        onPressed: () async {
          await Navigator.pushNamed(context, EditUserProfilePage.kRoute,
              arguments: user);
          _userProfileBloc.getUser();
        },
      ),
    );
  }

  Text _bio(User user) {
    return Text(
      user.bio,
    );
  }

  Text _bioLabel() {
    return Text(
      "Bio",
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text _userEmail(User user) {
    return Text(
      user.email,
      textAlign: TextAlign.center,
    );
  }

  Text _userName(User user) {
    return Text(
      StringUtils.capitalize(user.firstName) +
          " " +
          StringUtils.capitalize(user.lastName),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Align _profileImage(String imageUrl) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: Colors.green, width: 1)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: imageUrl.isNotEmpty
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Image.network(
                      imageUrl,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              : Icon(
                  CupertinoIcons.person_solid,
                  color: Colors.green,
                  size: 150.0,
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userProfileBloc.dispose();
    super.dispose();
  }
}
