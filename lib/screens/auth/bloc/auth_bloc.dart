import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eventapp/model/user.dart';
import 'package:eventapp/service/auth_service.dart';
import 'package:eventapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthInitial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginSuccessEvent) {
      yield ProfileCreatedState();
    } else if (event is SignUpSuccessEvent) {
      yield SignUpSuccessState();
    } else if (event is CreateUserProfileEvent) {
      yield LoggedInSuccessState(event.user);
    } else if (event is CheckUserEvent) {
      User user = await AuthService.instance.getUserIfLoggedIn();
      if (user != null) {
        yield ProfileCreatedState();
      }
    }
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _errorMessage = BehaviorSubject<String>();

  Stream<String> get errorMessage => _errorMessage.stream;

  final _loadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get loading => _loadingSubject.stream;

  final _emailValidSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get emailValid => _emailValidSubject.stream;

  Future<String> _registerUser(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user.sendEmailVerification();
      return result.user.uid;
    } catch (error) {
      return Future.error(_firebaseError(error.code));
    }
  }

  Future<FirebaseUser> _login(String email, String password) async {
    try {
      dynamic result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      return Future.error(_firebaseError(error.code));
    }
  }

  login(String email, String password) {
    _loadingSubject.sink.add(true);
    _login(email, password).then(
      (firebaseUser) async {
        _loadingSubject.sink.add(false);
        if (!firebaseUser.isEmailVerified) {
          _errorMessage.sink.add("Email is not verfied, Please check email and click on verification link");
        } else {
          final user = await AuthService.instance.getUserIfLoggedIn();
          if (user == null) {
            add(CreateUserProfileEvent(
                User(id: firebaseUser.uid, email: email)));
          } else {
            add(LoginSuccessEvent());
          }
        }
      },
    ).catchError(
      (error) {
        _errorMessage.sink.add(error);
        _loadingSubject.sink.add(false);
      },
    );
  }

  signUp(String email, String password) {
    _loadingSubject.sink.add(true);
    _registerUser(email, password).then((value) {
      add(SignUpSuccessEvent());
      _loadingSubject.sink.add(false);
    }).catchError((error) {
      _loadingSubject.sink.add(false);
      _errorMessage.sink.add(error);
    });
  }

  Future<void> resetPassword(String email) async {
    await AuthService.instance.resetPassword(email);
  }

  void onChangeRestEmail(String email) {
    if (Validator.validEmail(email)) {
      _emailValidSubject.sink.add(true);
    } else {
      _emailValidSubject.sink.add(false);
    }
  }

  String _firebaseError(String code) {
    switch (code) {
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Anonymous accounts are not enabled";
      case "ERROR_WEAK_PASSWORD":
        return "Your password is too weak";
      case "ERROR_INVALID_EMAIL":
        return "Your email is invalid";
      case "ERROR_USER_NOT_FOUND":
        return "Your email is not registered with us please signup";
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Email is already in use on different account";
      case "ERROR_INVALID_CREDENTIAL":
        return "Your email is invalid";
      case "ERROR_WRONG_PASSWORD":
        return "Password is incorrect";
      default:
        return "An undefined Error happened.";
    }
  }

  dispose() {
    _emailValidSubject.close();
    _errorMessage.close();
    _loadingSubject.close();
  }
}
