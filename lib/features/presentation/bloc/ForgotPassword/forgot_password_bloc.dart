import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEvent>((event, emit) {});

    on<SendResetLink>((event, emit) {
      try {
        sendPasswordResetEmail(event.email);
        emit(ForgotPasswordSend());
      } catch (e) {
        emit(ResetLinkFailed(e.toString()));
      }
    });
  }
}

Future<void> sendPasswordResetEmail(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } catch (e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          break;
        case 'invalid-email':
          break;
        default:
      }
    }
  }
}