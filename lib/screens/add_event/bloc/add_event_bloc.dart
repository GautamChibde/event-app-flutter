import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  @override
  AddEventState get initialState => AddEventInitial();

  final _imageUrlSubject = BehaviorSubject<String>();

  Stream<String> get imageUrl => _imageUrlSubject.stream;

  AddEventBloc() {
    _date = DateTime.now().millisecondsSinceEpoch;
  }

  int _startTime;
  int endTime;
  int _date;

  String get formattedDate => DateFormat("dd/MM/yyyy")
      .format(DateTime.fromMillisecondsSinceEpoch(_date));

  String get formattedStartTime => DateFormat("h:m a")
      .format(DateTime.fromMillisecondsSinceEpoch(_startTime));

  @override
  Stream<AddEventState> mapEventToState(
    AddEventEvent event,
  ) async* {}

  updateImage(String imagePath) {
    _imageUrlSubject.sink.add(imagePath);
  }

  @override
  Future<void> close() {
    _imageUrlSubject.close();
    return super.close();
  }

  setDate(int date) {
    this._date = date;
  }

  setStartTime(int time) {
    this._startTime = time;
  }
}
