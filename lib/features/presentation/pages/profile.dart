// ...existing code...
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/presentation/Widget/profile/custom_profile.dart';
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
        String? imageUrl;
        if (state is AuthenticatedState) {
          userName = state.username ?? 'Unknown User';
          userEmail = state.email ?? 'Not Available';
          if (state.user != null && state.user!.photoURL != null) {
            imageUrl = state.user!.photoURL;
          }
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              if (imageUrl != null && imageUrl.isNotEmpty)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imageUrl),
                  backgroundColor: Colors.grey[200],
                  onBackgroundImageError: (_, __) => {},
                )
              else
                const Icon(Icons.person, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                userName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                userEmail,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Menu(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
