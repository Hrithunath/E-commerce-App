import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/domain/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;

  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>(checkLoginStatusEvent);
    on<LoginEvent>(loginEvent);
    on<SignUpEvent>(signUpEvent);
    on<LogoutEvent>(logoutEvent);
    on<GoogleSignInEvent>(googleSignInEvent);
  }

  FutureOr<void> checkLoginStatusEvent(
      CheckLoginStatusEvent event, Emitter<AuthState> emit) async {
    try {
      user = _auth.currentUser;

      if (user != null) {
        // Fetch additional user data from Firestore
        final DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user!.uid)
                .get(const GetOptions(source: Source.server));

        if (userData.exists) {
          final String? username = userData.data()?["name"];
          final String? email = userData.data()?["email"];

          emit(AuthenticatedState(
            user: user,
            username: username,
            email: email,
          ));
        } else {
          emit(AuthenticatedState(user: user));
        }
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.user.email.toString(),
          password: event.user.password.toString());

      final user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "name": event.user.name,
          "createdAt": DateTime.now(),
        });
        emit(AuthenticatedState(user: user));
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> logoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _auth.signOut();
      emit(UnAuthenticatedState());
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      final user = userCredential.user;

      if (user != null) {
        // Fetch additional user data from Firestore
        final DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get();

        if (userData.exists) {
          // Extract user details from the document
          final String? username = userData.data()?["name"];
          final String? email = userData.data()?["email"];

          print('inside login $username : $email');

          // Emit the authenticated state with user details
          emit(
              AuthenticatedState(user: user, username: username, email: email));
        } else {
          emit(AuthenticatedState(user: user)); // No additional data found
        }
      } else {
        emit(UnAuthenticatedState());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState(errorMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState(errorMessage: 'Wrong password provided.'));
      } else {
        emit(AuthErrorState(errorMessage: 'Firebase Auth error: ${e.message}'));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> googleSignInEvent(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // retrieves the authentication tokens (ID token and access token) for the signed-in Google user.
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          final username = user.displayName ?? 'Guest';
          final email = user.email ?? 'No email provided';
          final phone = user.phoneNumber ?? '';

          // Add more detailed logging here
          print('User object is not null');
          print('Username: $username');
          print('Email: $email');

          // Save user details to Firestore
          final userDoc =
              FirebaseFirestore.instance.collection('users').doc(user.uid);

          // Check if user document already exists
          final userSnapshot = await userDoc.get();
          if (!userSnapshot.exists) {
            await userDoc.set({
              'uid': user.uid,
              'email': email,
              'name': username,
              'phoneNumber': phone,
              'createdAt': DateTime.now(),
            });

            print('User details saved to Firestore.');
          } else {
            print('User already exists in Firestore.');
          }

          emit(AuthenticatedState(username: username, email: email));
        } else {
          print('Google Sign-In failed: User object is null');
          emit(UnAuthenticatedState());
        }
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }
}
