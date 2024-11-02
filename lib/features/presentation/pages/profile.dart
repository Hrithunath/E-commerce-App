import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/profile/custom_profile.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print(
            'Current AuthState: ${state.runtimeType}'); // Debug log for state tracking

        if (state is AuthInitial) {
          return const Center(child: Text('Initializing...'));
        } else if (state is AuthLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthenticatedState) {
          final String userName = state.username ?? 'Unknown';
          final String userEmail = state.email ?? 'No email available';

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
        } else if (state is UnAuthenticatedState) {
          return const Center(
              child: Text('Please log in to access your profile.'));
        } else if (state is AuthErrorState) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

        // Fallback for any unhandled states
        return Center(child: Text('Unhandled state: ${state.runtimeType}'));
      },
    );
  }
}
