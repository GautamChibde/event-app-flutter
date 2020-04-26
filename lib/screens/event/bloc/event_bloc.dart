import 'package:eventapp/model/event.dart';
import 'package:eventapp/repository/event_repository.dart';
import 'package:eventapp/service/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class EventBloc {
  final FirebaseEventRepository _eventRepository;

  final _eventsSubject = BehaviorSubject<List<Event>>();

  Stream<List<Event>> get events => _eventsSubject.stream;

  final _userImageSubject = BehaviorSubject<String>();

  Stream<String> get userImage => _userImageSubject.stream;

  EventBloc(this._eventRepository) {
    _eventRepository.getAll().listen((List<Event> event) {
      _eventsSubject.sink.add(event);
    });

    AuthService.instance.getUser().listen(
      (user) {
        if (user.imageUrl.isNotEmpty) {
          _userImageSubject.sink.add(user.imageUrl);
        } else {
          _userImageSubject.sink.add("");
        }
      },
    );
  }

  dispose() {
    _eventsSubject.close();
    _userImageSubject.close();
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
}
