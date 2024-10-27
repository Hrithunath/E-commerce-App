import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/presentation/Widget/profile/profile.dart';
import 'package:e_commerce_app/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
      // context.read<UserBloc>().add(Fetch);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed out successfully!')),
          );
          Navigator.pushReplacementNamed(context, "/Login");
        } else if (state is SignOutfailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign out failed! Please try again.')),
          );
        }
      },
      builder: (context, state) {
        String userName = 'Unknown';
        String userEmail = 'No email available';

        if (state is Authenticated) {
          
          if (state.user != null) {
            userName = state.user?.displayName ?? 'Unknown';
            userEmail = state.user?.email ?? 'No email available';
            print('AuthenticatedState received with username: $userName, email: $userEmail'); // Improved logging
          } else {
            print('AuthenticatedState received but user is null');
          }
        } else {
          print('Current state is not authenticated: ${state.runtimeType}');
        }

        return SafeArea(
          child: Column(
            children: [
              Container(
                color: AppColors.primarycolor,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                userName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 200, 200, 200),
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Expanded(
                child: Menu(),
              ),
            ],
          ),
        );
      },
    );
  }
}
