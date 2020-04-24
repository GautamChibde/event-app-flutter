part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class AddUserEvent extends UserEvent {
  final String firstName;
  final String lastName;
  final String bio;

  AddUserEvent({
    this.firstName,
    this.lastName,
    this.bio,
  });
}
