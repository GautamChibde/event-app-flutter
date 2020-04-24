part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginSuccessEvent extends AuthEvent {}

class CheckUserEvent extends AuthEvent {}

class CreateUserProfileEvent extends AuthEvent {
  final User user;

  CreateUserProfileEvent(this.user);
}

class SignUpSuccessEvent extends AuthEvent {}
