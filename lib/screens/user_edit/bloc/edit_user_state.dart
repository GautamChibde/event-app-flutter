part of 'edit_user_bloc.dart';

@immutable
abstract class EditUserState {}

class EditUserInitial extends EditUserState {}

class UserInitial extends EditUserState {}

class UserProfileCreated extends EditUserState {}
