import 'dart:async';

import 'package:bloc/bloc.dart';
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

  UserBloc(this.userRepository, this.user);

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
    _loadingSubject.close();
    return super.close();
  }
}
