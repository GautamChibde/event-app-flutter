import 'dart:io';

import 'package:eventapp/repository/event_repository.dart';
import 'package:eventapp/screens/add_event/bloc/add_event_bloc.dart';
import 'package:eventapp/service/firebase_storage_service.dart';
import 'package:eventapp/utils/image_utils.dart';
import 'package:eventapp/utils/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatefulWidget {
  static const kRoute = "/addevent";

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AddEventBloc _addEventBloc;

  @override
  void initState() {
    _addEventBloc = AddEventBloc(
      FirebaseEventRepository.instance,
      FirebaseStorageService.instance,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dateController.text = _addEventBloc.formattedDate;
    _startTimeController.text = _addEventBloc.formattedStartTime;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("New Event")),
      ),
      backgroundColor: Colors.white,
      body: _body(context),
      bottomNavigationBar: BottomAppBar(
        child: StreamBuilder<bool>(
            stream: _addEventBloc.loading,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await _addEventBloc.createEvent(
                        _nameController.text,
                        _descriptionController.text,
                        _locationController.text,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: snapshot.data
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              );
            }),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _inputName(context),
              SizedBox(height: 16),
              _inputDescription(context),
              SizedBox(height: 16),
              _inputLocation(),
              Row(
                children: [
                  Flexible(flex: 1, child: _inputDate(context)),
                  SizedBox(width: 16),
                  Flexible(flex: 1, child: _inputStartTime(context)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _labelDuration(),
                  SizedBox(width: 8),
                  _inputDuration(),
                ],
              ),
              SizedBox(height: 16),
              _inputDurationSlider(),
              SizedBox(height: 16),
              _inputImage(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputDurationSlider() {
    return Slider(
      min: 30,
      max: 480,
      divisions: 30,
      value: _addEventBloc.duration,
      onChanged: (v) {
        setState(
          () {
            _addEventBloc.duration = v;
          },
        );
      },
    );
  }

  Text _labelDuration() {
    return Text(
      "DURATION:",
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _inputDuration() {
    return Text(
      _addEventBloc.getTime(),
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _inputName(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter name";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixStyle: TextStyle(color: Colors.green),
        labelText: "Name",
      ),
    );
  }

  Widget _inputDescription(BuildContext context) {
    return TextFormField(
      controller: _descriptionController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter description";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixStyle: TextStyle(color: Colors.green),
        labelText: "Description",
      ),
    );
  }

  _inputLocation() {
    return TextFormField(
      controller: _locationController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter location";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixStyle: TextStyle(color: Colors.green),
        labelText: "Location",
      ),
    );
  }

  Widget _inputDate(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _showDatePicker(context);
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.calendar_today),
              ),
              labelText: "Date",
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputStartTime(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final startTime = await _showTimePicker(_startTimeController);
        _addEventBloc.setStartTime(startTime.millisecondsSinceEpoch);
        _startTimeController.text = _addEventBloc.formattedStartTime;
      },
      child: Container(
        color: Colors.transparent,
        child: IgnorePointer(
          child: TextFormField(
            controller: _startTimeController,
            readOnly: true,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.time,
                ),
              ),
              labelText: "Start Time",
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputImage(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _captureImage(null);
      },
      child: StreamBuilder<String>(
        stream: _addEventBloc.imageUrl,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: _imagePlaceholder(),
            );
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFB7B7B7), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(snapshot.data),
              ),
            ),
          );
        },
      ),
    );
  }

  Container _imagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFB7B7B7), width: 1),
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.photo_camera,
          color: Color(0xFFB7B7B7),
          size: 100,
        ),
      ),
    );
  }

  Future<DateTime> _showTimePicker(TextEditingController controller) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final timeNow = DateTime.now();
      final updatedTime = DateTime(
          timeNow.year,
          timeNow.month,
          timeNow.day,
          time.hour,
          time.minute,
          timeNow.second,
          timeNow.millisecond,
          timeNow.microsecond);
      return updatedTime;
    }
    return null;
  }

  Future _showDatePicker(BuildContext context) async {
    final dateTime = await showDateTime(context);
    if (dateTime != null) {
      _addEventBloc.setDate(dateTime.millisecondsSinceEpoch);
      setState(() {
        _dateController.text = _addEventBloc.formattedDate;
      });
    }
  }

  Future<DateTime> showDateTime(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
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
      );
      if (imageFile != null) {
        await _addEventBloc.updateImage(imageFile.path);
      }
    }
  }
}
