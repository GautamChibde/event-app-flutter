import 'dart:io';

import 'package:eventapp/model/user.dart';
import 'package:eventapp/repository/user_repository.dart';
import 'package:eventapp/screens/event/events_page.dart';
import 'package:eventapp/screens/user/bloc/user_bloc.dart';
import 'package:eventapp/utils/image_utils.dart';
import 'package:eventapp/utils/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class EditUserProfilePage extends StatefulWidget {
  final User user;
  static const kRoute = "/userProfile";

  const EditUserProfilePage({Key key, this.user}) : super(key: key);
  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState(user);
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();

  final User user;

  _EditUserProfilePageState(this.user);

  UserBloc _userBloc;

  @override
  void initState() {
    _userBloc = UserBloc(UserRepository(), this.user);
    _firstNameController..text = user.firstName ?? "";
    _lastNameController..text = user.lastName ?? "";
    _bioController..text = user.bio ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is UserProfileCreated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            EventsPage.kRoute,
            (Route<dynamic> route) => false,
          );
        }
      },
      bloc: _userBloc,
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Create Profile",
            ),
          ),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _profileImage(),
          SizedBox(height: 16),
          _firstName(),
          SizedBox(height: 12),
          _lastName(),
          SizedBox(height: 12),
          _bio(),
          SizedBox(height: 12),
          _save()
        ],
      ),
    );
  }

  Widget _profileImage() {
    return GestureDetector(
      onTap: () {
        _captureImage();
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.account_circle,
              color: Colors.lightGreen,
              size: 200.0,
            ),
          ),
          Positioned(
            bottom: 16,
            left: MediaQuery.of(context).size.width / 2 + 24,
            child: Icon(
              Icons.camera_alt,
              size: 36,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }

  Widget _firstName() {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: new BorderSide(),
        ),
      ),
    );
  }

  Widget _lastName() {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Last Name",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: new BorderSide(),
        ),
      ),
    );
  }

  Widget _bio() {
    return TextFormField(
      maxLines: 3,
      controller: _bioController,
      decoration: InputDecoration(
        labelText: "bio",
        hintText: "bio",
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: new BorderSide(),
        ),
      ),
    );
  }

  Widget _save() {
    return MaterialButton(
      child: StreamBuilder<bool>(
          stream: _userBloc.loading,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Error");
            if (snapshot.data) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              );
            }
            return Text("Save".toUpperCase());
          }),
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () => _onSave(),
    );
  }

  _onSave() {
    _userBloc.add(AddUserEvent(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      bio: _bioController.text,
    ));
  }

  Future _captureImage() async {
    bool permissionGranted = true;
    if (Platform.isAndroid) {
      permissionGranted = await PermissionsService.instance.requestStoragePermission();
    }
    if (permissionGranted) {
      File imageFile = await ImageUtils.pickImage(
        context
      );
      // if (imageFile != null) {
      //   _accountManagerBloc.dispatch(UpdateImageEvent(imageFile.path));
      // }
    }
  }
}
