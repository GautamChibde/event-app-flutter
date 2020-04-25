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
    _eventBloc = EventBloc(FirebaseEventRepository());
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
    return _body(context);
  }

  Scaffold _body(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcomming events"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, UserProfilePage.kRoute);
            },
          )
        ],
      ),
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
      body: _eventStreamBuilder(),
    );
  }

  Widget _eventStreamBuilder() {
    return StreamBuilder(
      stream: _eventBloc.events,
      builder: (context, AsyncSnapshot<List<Event>> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          itemCount: snapshot.data.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return _createItem(snapshot.data[index]);
          },
        );
      },
    );
  }

  Widget _createItem(Event event) {
    var date = new DateTime.fromMillisecondsSinceEpoch(event.date);
    var formattedDate = new DateFormat("yyyy.mm.dd").format(date);
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.fill,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    formattedDate,
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.title,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventBloc.dispose();
    super.dispose();
  }
}
