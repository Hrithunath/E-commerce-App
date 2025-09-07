import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/Widget/profile/custom_profile.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        String userName = 'Unknown User';
        String userEmail = 'Not Available';

        if (state is AuthenticatedState) {
          userName = state.username ?? 'Unknown User';
          userEmail = state.email ?? 'Not Available';
        }

        return SafeArea(
          child: Scaffold(
        
            body: Column(
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
          ),
        );
      },
    );
  }
}
