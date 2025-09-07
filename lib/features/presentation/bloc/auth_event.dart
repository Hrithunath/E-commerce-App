part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckLoginStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final UserModel user;

  SignUpEvent({required this.user});
}

class GoogleSignInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
