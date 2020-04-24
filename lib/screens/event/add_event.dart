import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _imageController = TextEditingController();

  final double _imageHeightRatio = 9 / 16;

  int _dateEpoch;

  @override
  Widget build(BuildContext context) {
    _dateEpoch = DateTime.now().millisecondsSinceEpoch;
    _dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("New Event")),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Firestore.instance
              .collection("event")
              .add({
                "name": _nameController.text,
                "image": _imageController.text,
                "description": _descriptionController.text,
                "date": _dateEpoch
              })
              .then((result) => {
                    Navigator.pop(context),
                  })
              .catchError((err) => print(err));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _inputName(context),
                SizedBox(height: 16),
                _inputDescription(context),
                SizedBox(height: 16),
                _inputImage(context),
                SizedBox(height: 16),
                _inputDate(context),
              ],
            ),
          ),
        ),
      ),
    );
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
    return TextFormField(
      controller: _imageController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        suffixStyle: TextStyle(color: Colors.green),
        labelText: "Image",
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

  Future _showDatePicker(BuildContext context) async {
    final dateTime = await showDateTime(context);
    if (dateTime != null) {
      _dateEpoch = dateTime.millisecondsSinceEpoch;
      setState(() {
        _dateController.text = DateFormat("dd/MM/yyyy").format(dateTime);
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
}
