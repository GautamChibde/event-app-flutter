part of 'edit_user_bloc.dart';

@immutable
abstract class EditUserEvent {}

class AddUserEvent extends EditUserEvent {
  final String firstName;
  final String lastName;
  final String bio;

  AddUserEvent({
    this.firstName,
    this.lastName,
    this.bio,
  });
}