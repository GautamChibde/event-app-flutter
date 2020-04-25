import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:eventapp/firebase_storage_service.dart';
import 'package:eventapp/model/user.dart';
import 'package:eventapp/repository/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final User user;

  final _loadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get loading => _loadingSubject.stream;

  final _imageUrlSubject = BehaviorSubject<String>();

  Stream<String> get imageUrl => _imageUrlSubject.stream;

  final _imageLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get imageLoading => _imageLoadingSubject.stream;

  UserBloc(this.userRepository, this.user) {
    if (user.imageUrl != null || user.imageUrl.isNotEmpty) {
      _imageUrlSubject.sink.add(user.imageUrl);
    }
  }

  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is AddUserEvent) {
      _loadingSubject.sink.add(true);
      await userRepository.add(
        user.copyWith(
          firstName: event.firstName,
          email: user.email,
          lastName: event.lastName,
          bio: event.bio,
        ),
      );
    }
    yield UserProfileCreated();
  }

  @override
  Future<void> close() {
    _imageLoadingSubject.close();
    _loadingSubject.close();
    _imageUrlSubject.close();
    return super.close();
  }

  Future<void> removeImage() async {
    _imageLoadingSubject.sink.add(true);
    await FirebaseStorageService.instance.deleteImage(_imageUrlSubject.value);
    await userRepository.update(
      user.copyWith(
        imageUrl: "",
      ),
    );
    _imageLoadingSubject.sink.add(false);
    _imageUrlSubject.sink.add("");
  }

  Future<void> updateImage(File imageFile) async {
    _imageLoadingSubject.sink.add(true);
    if (_imageUrlSubject.value != null && _imageUrlSubject.value.isNotEmpty) {
      await FirebaseStorageService.instance.deleteImage(_imageUrlSubject.value);
    }
    String path = await FirebaseStorageService.instance.uploadImage(imageFile);
    await userRepository.update(
      user.copyWith(
        imageUrl: path,
      ),
    );
    _imageUrlSubject.sink.add(path);
    _imageLoadingSubject.sink.add(false);
  }
}
