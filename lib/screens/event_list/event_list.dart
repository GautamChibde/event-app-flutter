import 'package:eventapp/model/event.dart';
import 'package:eventapp/repository/event_repository.dart';
import 'package:eventapp/screens/event_list/event_list_bloc.dart';
import 'package:eventapp/utils/event_type.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  final EventType eventType;
  EventList(this.eventType, {Key key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState(this.eventType);
}

class _EventListState extends State<EventList> {
  EventListBloc _eventListBloc;
  EventType eventType;

  _EventListState(this.eventType);

  @override
  void initState() {
    _eventListBloc = EventListBloc(
      FirebaseEventRepository.instance,
      eventType: this.eventType,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _eventListBloc.events,
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
                  _eventListBloc.getDuration(event.startTime, event.endTime),
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
                    _eventListBloc.getDay(event.date),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _eventListBloc.getMonth(event.date),
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
    _eventListBloc.dispose();
    super.dispose();
  }
}
