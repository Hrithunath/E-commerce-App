import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:e_commerce_app/features/presentation/pages/cart.dart';
import 'package:e_commerce_app/features/presentation/pages/favourite.dart';
import 'package:e_commerce_app/features/presentation/pages/home.dart';
import 'package:e_commerce_app/features/presentation/pages/profile.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';

class HomeBottomnavigation extends StatefulWidget {
  final int initialIndex;
  const HomeBottomnavigation({super.key, this.initialIndex = 0});

  @override
  State<HomeBottomnavigation> createState() => _HomeBottomnavigationState();
}

class _HomeBottomnavigationState extends State<HomeBottomnavigation> {
  late int _currentIndex;

  final List<Widget> pages = [
    const Home(),
    const Favourite(),
    const Cart(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final double safeBottom = MediaQuery.of(context).padding.bottom;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticatedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil("/Login", (route) => false);
            }
          });
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldExit = await _onWillPop(context);
          if (shouldExit) SystemNavigator.pop();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex.clamp(0, pages.length - 1),
                children: pages,
              ),
              Positioned(
                bottom: safeBottom + 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 3,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMorphingNavItem(
                        context,
                        Icons.home_outlined,
                        "Home",
                        0,
                      ),
                      _buildMorphingNavItem(
                        context,
                        Icons.favorite_border,
                        "Wishlist",
                        1,
                      ),
                      _buildMorphingNavItem(
                        context,
                        Icons.shopping_cart,
                        "Cart",
                        2,
                      ),
                      _buildMorphingNavItem(
                        context,
                        Icons.person_outline,
                        "Profile",
                        3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldPop = await DialogHelper.showAlertDialog<bool>(
      context: context,
      title: "Exit App",
      content: const Text(
        "Do you want to exit the application?",
        textAlign: TextAlign.center,
      ),
      cancelText: "No",
      confirmText: "Yes",
      onCancel: () => Navigator.of(context).pop(false),
      onConfirm: () => Navigator.of(context).pop(true),
    );
    return shouldPop ?? false;
  }

  Widget _buildMorphingNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = _currentIndex == index;
    final iconColor = isSelected ? Colors.white : Colors.grey[600];
    final textColor = isSelected ? Colors.white : Colors.grey[600];

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarycolor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
            if (!isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
