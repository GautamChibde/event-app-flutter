import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:eventapp/model/event.dart';
import 'package:eventapp/repository/event_repository.dart';
import 'package:eventapp/service/firebase_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'add_event_event.dart';
part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  int _startTime;
  int _date;

  double duration = 30;

  final FirebaseEventRepository _firebaseEventRepository;
  final FirebaseStorageService _storageService;

  final _imageUrlSubject = BehaviorSubject<String>();

  Stream<String> get imageUrl => _imageUrlSubject.stream;

  Function(String) get updateImage => _imageUrlSubject.sink.add;

  final _loadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get loading => _loadingSubject.stream;

  String getTime() {
    final hour = this.duration / 60;
    final minute = this.duration % 60;
    return "${hour.toInt()} h ${minute.toInt()} min";
  }

  AddEventBloc(this._firebaseEventRepository, this._storageService) {
    _date = DateTime.now().millisecondsSinceEpoch;
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  String get formattedDate => DateFormat("dd/MM/yyyy")
      .format(DateTime.fromMillisecondsSinceEpoch(_date));

  String get formattedStartTime => DateFormat("h:m a")
      .format(DateTime.fromMillisecondsSinceEpoch(_startTime));

  @override
  AddEventState get initialState => AddEventInitial();

  @override
  Stream<AddEventState> mapEventToState(
    AddEventEvent event,
  ) async* {}

  setDate(int date) {
    this._date = date;
  }

  setStartTime(int time) {
    this._startTime = time;
  }

  Future<void> createEvent(
      String name, String description, String location) async {
    _loadingSubject.sink.add(true);
    final hr = duration / 60;
    final min = duration % 60;
    final selectedDate = DateTime.fromMillisecondsSinceEpoch(_date);
    final updatedEndTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hr.toInt(),
      min.toInt(),
      selectedDate.second,
      selectedDate.millisecond,
      selectedDate.microsecond,
    );
    final startTime = DateTime.fromMillisecondsSinceEpoch(_startTime);
    final updatedStartTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
      selectedDate.second,
      selectedDate.millisecond,
      selectedDate.microsecond,
    );
    String remotePath = "";
    if (_imageUrlSubject.value != null) {
      remotePath =
          await _storageService.uploadImage(File(_imageUrlSubject.value));
    }
    await _firebaseEventRepository.add(
      Event(
        name,
        description,
        location,
        _date,
        updatedStartTime.millisecondsSinceEpoch,
        updatedEndTime.millisecondsSinceEpoch,
        imageUrl: remotePath,
      ),
    );
    _loadingSubject.sink.add(false);
  }

  @override
  Future<void> close() {
    _imageUrlSubject.close();
    _loadingSubject.close();
    return super.close();
  }
}
