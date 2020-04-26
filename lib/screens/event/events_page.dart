import 'package:eventapp/screens/add_event/add_event.dart';
import 'package:eventapp/screens/auth/login_page.dart';
import 'package:eventapp/screens/event/event_bloc.dart';
import 'package:eventapp/screens/event_list/event_list.dart';
import 'package:eventapp/screens/user/user_profile_page.dart';
import 'package:eventapp/utils/event_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  static const kRoute = "/events";

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  EventBloc _eventBloc;
  TabController _tabController;
  @override
  void initState() {
    _eventBloc = EventBloc();
    _tabController = new TabController(length: 2, vsync: this);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appBar(),
          SizedBox(height: 8),
          _tabBar(),
          SizedBox(height: 8),
          _tabBarView()
        ],
      ),
    );
  }

  Expanded _tabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          EventList(EventType.upcomming),
          EventList(EventType.past),
        ],
      ),
    );
  }

  Padding _tabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TabBar(
        isScrollable: true,
        labelColor: Colors.black,
        controller: _tabController,
        indicatorWeight: 4,
        tabs: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              "Upcomming",
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          Container(
            child: Text(
              "Past",
              style: TextStyle(
                fontSize: 19,
              ),
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

  @override
  void dispose() {
    _eventBloc.dispose();
    super.dispose();
  }
}
