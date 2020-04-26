import 'package:eventapp/model/event.dart';
import 'package:eventapp/repository/event_repository.dart';
import 'package:eventapp/screens/add_event/add_event.dart';
import 'package:eventapp/screens/auth/login_page.dart';
import 'package:eventapp/screens/event/bloc/event_bloc.dart';
import 'package:eventapp/screens/user/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  static const kRoute = "/events";

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  EventBloc _eventBloc;

  @override
  void initState() {
    _eventBloc = EventBloc(FirebaseEventRepository.instance);
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          LoginPage.kRoute,
          (Route<dynamic> route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddEvent(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          _appBar(),
          Expanded(
            child: StreamBuilder(
              stream: _eventBloc.events,
              builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return _createItem(
                      snapshot.data[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Container(
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Events",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, UserProfilePage.kRoute);
            },
            child: StreamBuilder<String>(
              stream: _eventBloc.userImage,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Icon(
                    Icons.account_circle,
                    size: 48,
                  );
                }
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    child: Image.network(
                      snapshot.data,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createItem(Event event) {
    return Card(
      elevation: 1,
      color: Color(0xFFF9FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _eventImage(event),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16),
                Text(
                  event.title.trim(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  event.location.trim(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _eventBloc.getDuration(event.startTime, event.endTime),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect _eventImage(Event event) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: event.imageUrl.isEmpty
                ? Image.asset("images/event_placeholder.jpeg")
                : Image.network(
                    event.imageUrl,
                    fit: BoxFit.fill,
                  ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 70,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _eventBloc.getDay(event.date),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _eventBloc.getMonth(event.date),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _eventBloc.dispose();
    super.dispose();
  }
}
