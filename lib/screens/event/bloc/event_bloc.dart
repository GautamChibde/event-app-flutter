import 'package:bloc/bloc.dart';
import 'package:eventapp/model/event.dart';
import 'package:eventapp/repository/event_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class EventBloc {
  final FirebaseEventRepository repository;

  final _eventsSubject = BehaviorSubject<List<Event>>();

  Stream<List<Event>> get events => _eventsSubject.stream;

  EventBloc(this.repository) {
    repository.getAll().listen((List<Event> event) {
      _eventsSubject.sink.add(event);
    });
  }

  dispose() {
    _eventsSubject.close();
  }
}
