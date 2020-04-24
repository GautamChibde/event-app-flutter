part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class SignUpSuccessState extends AuthState {}

class LoggedInSuccessState extends AuthState {
  final User user;

  LoggedInSuccessState(this.user);
}

class ProfileCreatedState extends AuthState {}
