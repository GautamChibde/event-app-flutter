import 'package:eventapp/model/user.dart';
import 'package:eventapp/service/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class UserProfileBloc {
  final _userSubject = BehaviorSubject<User>();

  Stream<User> get user => _userSubject.stream;

  UserProfileBloc() {
    getUser();
  }

  Future<void> getUser() async {
    await AuthService.instance
        .getUserIfLoggedIn()
        .then((value) => _userSubject.sink.add(value))
        .catchError((onError) { print("onError");});
  }

  dispose() {
    _userSubject.close();
  }
}
