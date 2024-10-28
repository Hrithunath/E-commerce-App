part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
class CheckLoginStatusEvent extends AuthEvent {}

class  SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email,required this.password});
}

class SignUpEvent extends AuthEvent{
 
 final UserModel user;
 SignUpEvent({required this.user});
}

class FacebookSignInEvent extends AuthEvent{
  
}

class GoogleSignInEvent extends AuthEvent{
  
}

class LogoutEvent extends AuthEvent{
  
}