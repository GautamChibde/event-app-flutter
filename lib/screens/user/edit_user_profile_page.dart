import 'dart:io';

import 'package:eventapp/model/user.dart';
import 'package:eventapp/repository/user_repository.dart';
import 'package:eventapp/screens/event/events_page.dart';
import 'package:eventapp/screens/user/bloc/user_bloc.dart';
import 'package:eventapp/utils/image_utils.dart';
import 'package:eventapp/utils/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return StreamBuilder<String>(
        stream: _userBloc.imageUrl,
        builder: (context, AsyncSnapshot<String> snapshotImage) {
          return GestureDetector(
            onTap: () async {
              if (snapshotImage.hasData) {
                await _captureImage(snapshotImage.data);
              }
            },
            child: StreamBuilder<bool>(
                stream: _userBloc.imageLoading,
                builder: (context, snapshotLoading) {
                  if (!snapshotLoading.hasData) return Text("error");
                  if (snapshotLoading.data || !snapshotImage.hasData)
                    return Center(
                      child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.green, spreadRadius: 4),
                            ],
                          ),
                          child: Center(child: CircularProgressIndicator())),
                    );
                  return _userProfileAvatar(context, snapshotImage.data);
                }),
          );
        });
  }

  Stack _userProfileAvatar(BuildContext context, String data) {
    print("image data " + data);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.green, spreadRadius: 4),
              ],
            ),
            child: Container(
              width: 200,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: data.isEmpty
                    ? Icon(
                        CupertinoIcons.person_solid,
                        color: Colors.green,
                        size: 200.0,
                      )
                    : Image.network(
                        data,
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width / 2 + 36,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.green,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.camera_alt,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
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

  Future _captureImage(String data) async {
    bool permissionGranted = true;
    if (Platform.isAndroid) {
      permissionGranted =
          await PermissionsService.instance.requestStoragePermission();
    }
    if (permissionGranted) {
      File imageFile = await ImageUtils.pickImage(
        context,
        onRemove: data == null
            ? null
            : () {
                _userBloc.removeImage();
              },
      );
      if (imageFile != null) {
        await _userBloc.updateImage(imageFile);
      }
    }
  }
}
