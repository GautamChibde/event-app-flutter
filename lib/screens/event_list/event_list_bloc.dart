import 'package:eventapp/model/event.dart';
import 'package:eventapp/repository/event_repository.dart';
import 'package:eventapp/utils/event_type.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class EventListBloc {
  EventType _eventType = EventType.upcomming;

  final FirebaseEventRepository _eventRepository;

  final _eventsSubject = BehaviorSubject<List<Event>>();

  Stream<List<Event>> get events => _eventsSubject.stream;

  EventListBloc(this._eventRepository, {EventType eventType}) {
    this._eventType = eventType ?? this._eventType;
    _eventRepository.getByType(this._eventType).listen(
      (List<Event> event) {
        _eventsSubject.sink.add(event);
      },
    );
  }

  String getDuration(int startTime, int endTime) {
    final st = DateTime.fromMillisecondsSinceEpoch(startTime);
    final et = DateTime.fromMillisecondsSinceEpoch(endTime);
    final formatt = DateFormat("h:mm a");
    return "${formatt.format(st)} - ${formatt.format(et)}";
  }

  String getDay(int date) {
    final formatt = DateFormat("d");
    return formatt.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  String getMonth(int date) {
    final formatt = DateFormat("MMM");
    return formatt.format(DateTime.fromMillisecondsSinceEpoch(date));
  }

  dispose() {
    _eventsSubject.close();
  }
}
