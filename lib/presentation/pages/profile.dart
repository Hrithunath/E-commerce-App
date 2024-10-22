import 'package:e_commerce_app/core/Theme/appcolors.dart';
import 'package:e_commerce_app/presentation/Widget/profile/profile.dart';
import 'package:e_commerce_app/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
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
        return SafeArea(
          child: Column(
            children: [
              Container(
                color: AppColors.primarycolor,
                padding: const EdgeInsets.all(20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hrithunath',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              'Hrithunath&777@gmail.com',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 200, 200, 200),
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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

