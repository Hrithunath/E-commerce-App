import 'dart:ui';

import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/pages/cart.dart';
import 'package:e_commerce_app/features/presentation/pages/favourite.dart';
import 'package:e_commerce_app/features/presentation/pages/home.dart';
import 'package:e_commerce_app/features/presentation/pages/profile.dart';
import 'package:flutter/material.dart';

class HomeBottomnavigation extends StatefulWidget {
  const HomeBottomnavigation({super.key});

  @override
  State<HomeBottomnavigation> createState() => _HomeBottomnavigationState();
}

class _HomeBottomnavigationState extends State<HomeBottomnavigation> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const Home(),
    const Cart(),
    const Favourite(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primarycolor,
        unselectedItemColor: AppColors.kgrey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}

