import 'dart:io';

import 'package:eventapp/screens/add_event/bloc/add_event_bloc.dart';
import 'package:eventapp/utils/image_utils.dart';
import 'package:eventapp/utils/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  static const kRoute = "/addevent";

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startTimeController = TextEditingController();

  AddEventBloc _addEventBloc;

  @override
  void initState() {
    _addEventBloc = AddEventBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("New Event")),
      ),
      backgroundColor: Colors.white,
      body: _body(context),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RaisedButton(
            color: Colors.green,
            onPressed: () {},
            child: Text(
              "SAVE",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _inputName(context),
              SizedBox(height: 16),
              _inputDescription(context),
              SizedBox(height: 16),
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
                  Text(
                    "DURATION:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    _getTime(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              Slider(
                  min: 30,
                  max: 480,
                  divisions: 11,
                  value: this.value,
                  onChanged: (v) {
                    setState(() {
                      this.value = v;
                    });
                  }),
              SizedBox(height: 16),
              _inputImage(context),
            ],
          ),
        ),
      ),
    );
  }

  double value = 60;

  String _getTime() {
    final hour = this.value / 60;
    final minute = this.value % 60;
    return "${hour.toInt()} h ${minute.toInt()} min";
  }

  Widget _inputName(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
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
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixStyle: TextStyle(color: Colors.green),
        labelText: "Description",
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey, width: 2),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.photo_camera,
          color: Colors.grey,
          size: 100,
        ),
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
