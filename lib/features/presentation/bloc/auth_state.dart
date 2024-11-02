// part of 'auth_bloc.dart';

// @immutable
// sealed class AuthState {}

// final class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class Authenticated extends AuthState {
//   User? user;
//   Authenticated(this.user);
// }

// class UnAuthenticated extends AuthState {}

// class AuthenticatedError extends AuthState {
//   final String message;
//   AuthenticatedError({required this.message});
// }

// class GoogleAuthSuccess extends AuthState {}

// class GoogleAuthFailed extends AuthState {}

// class SignOutSuccess extends AuthState {}

// class SignOutfailed extends AuthState {}

// ignore_for_file: must_be_immutable

part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  User? user;
  String? username;
  String? email;
  AuthenticatedState({this.user, this.username, this.email});
}

class UnAuthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;
  AuthErrorState({required this.errorMessage});
}
