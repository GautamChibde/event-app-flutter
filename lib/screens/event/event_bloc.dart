import 'package:eventapp/service/auth_service.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class EventBloc {
  final _userImageSubject = BehaviorSubject<String>();

  Stream<String> get userImage => _userImageSubject.stream;

  EventBloc() {
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
    _userImageSubject.close();
  }
}
