import 'package:eventapp/model/user.dart';
import 'package:eventapp/repository/auth_repository.dart';
import 'package:eventapp/screens/user/bloc/user_profile_bloc.dart';
import 'package:eventapp/screens/user/edit_user_profile_page.dart';
import 'package:eventapp/utils/utils.dart';
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
          if (!snapshot.hasData) return _initialLoader(context);
          final user = snapshot.data;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _profileImage(),
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
        AuthRepository.instance.signOut();
      },
    );
  }

  Expanded _editProfileButton(BuildContext context, User user) {
    return Expanded(
      child: OutlineButton(
        child: Text("Edit Profile"),
        onPressed: () {
          Navigator.pushNamed(context, EditUserProfilePage.kRoute,
              arguments: user);
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

  Align _profileImage() {
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(75.0),
        child: Image.network(
          "https://as01.epimg.net/en/imagenes/2019/09/24/football/1569310945_447431_noticia_normal.jpg",
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _initialLoader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
          height: 52,
          width: 52,
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
