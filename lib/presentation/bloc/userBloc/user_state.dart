part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserSuccessState extends UserState{
  final String name;
  final String email;

  UserSuccessState({required this.name, required this.email});
  
}

class UserErrorState extends UserState {
  
  final String errorMessage;

  UserErrorState({required this.errorMessage});
}