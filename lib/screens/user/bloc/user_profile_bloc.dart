import 'package:eventapp/model/user.dart';
import 'package:eventapp/repository/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserProfileBloc {
  final _userSubject = BehaviorSubject<User>();

  Stream<User> get user => _userSubject.stream;

  UserProfileBloc() {
    AuthRepository.instance
        .getUserIfLoggedIn()
        .then((value) => _userSubject.sink.add(value))
        .catchError((onError) { print("onError");});
  }

  dispose() {
    _userSubject.close();
  }
}
