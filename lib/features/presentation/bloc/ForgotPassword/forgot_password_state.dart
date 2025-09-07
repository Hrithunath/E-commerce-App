part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordSend extends ForgotPasswordState{
 

}
final class ResetLinkFailed extends ForgotPasswordState{
   final String error;

  ResetLinkFailed(this.error);
   
 
}