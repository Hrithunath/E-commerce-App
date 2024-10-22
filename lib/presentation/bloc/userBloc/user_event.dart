part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}
class FetchUserDetails extends UserEvent {
  
 final String userId;

  FetchUserDetails({required this.userId});
}