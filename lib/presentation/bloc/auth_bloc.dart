import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  

  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      User? user;
      try {
        await Future.delayed(const Duration(seconds: 2), () {
          user = auth.currentUser;
        });

        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    }
    );

    on<SignUpEvent>((event, emit) async {

      emit(AuthLoading());
      try{
      final UserCredential = await auth.createUserWithEmailAndPassword(
        email: event.user.email.toString(), 
        password: event.user.password.toString());

        final user = UserCredential.user;

        if (user!=null) {
          FirebaseFirestore.instance.collection("users").doc(user.uid).
          set({"uid":user.uid,
          "email":user.email,
          "name":event.user.name,
          
          "createdAt":DateTime.now(),
          });
          emit(Authenticated(user));
        }else{
          emit(UnAuthenticated());
        }
    }
    catch(e){

      emit(AuthenticatedError(message: e.toString()));
    }
    }

    );

    on<SignInEvent>((event, emit)async {
      emit(AuthLoading());
      
      try {
        
        final UserCredential = await auth.signInWithEmailAndPassword(
          email: event.email,
           password: event.password);
           final user = UserCredential.user;
           
           if (user!=null) {
             emit(Authenticated(user));
           }else{
            emit(UnAuthenticated());
           }
      } catch (e) {
        
        emit(AuthenticatedError(message: e.toString()));
      }
    });

      on<GoogleSignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        print("print from signin Event${googleUser!.displayName}");
        
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "uid": user.uid,
            "email": user.email,
            "name": user.displayName ?? "Unknown",
            "createdAt": DateTime.now(),
          });
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit)async {
      try {
        await auth.signOut();
        emit(SignOutSuccess());
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    },);
  }
}
