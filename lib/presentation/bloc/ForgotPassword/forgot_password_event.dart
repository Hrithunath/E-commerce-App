part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}

final class SendResetLink extends ForgotPasswordEvent{
   
   final String email ;

  SendResetLink( this.email);
   
}
