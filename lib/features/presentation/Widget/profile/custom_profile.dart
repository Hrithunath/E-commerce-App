import 'package:e_commerce_app/features/presentation/Widget/custom_alert_dialog.dart';
import 'package:e_commerce_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Menu extends StatelessWidget {
  const Menu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(
          context,
          title: 'MyOrders',
          icon: Icons.receipt_long_outlined,
          onTap: () => Navigator.pushNamed(context, "/MyOrders"),
        ),
        _buildDivider(),
        _buildMenuItem(
          context,
          title: 'Shipping Addresses',
          icon: Icons.location_on_outlined,
          onTap: () => Navigator.pushNamed(context, "/ShippedAddress"),
        ),
        _buildDivider(),
        _buildMenuItem(
          context,
          title: 'About',
          icon: Icons.info_outline,
          onTap: () => Navigator.pushNamed(context, "/About"),
        ),
        _buildDivider(),
        _buildMenuItem(
          context,
          title: 'Logout',
          icon: Icons.logout_outlined,
          onTap: () {
            DialogHelper.showAlertDialog(
              context: context,
              title: 'Confirm',
              content: const Text('Are you sure you want to sign out?'),
              confirmText: 'Logout',
              onConfirm: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
              },
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1E293B),
                size: 24,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.08),
      indent: 20,
      endIndent: 20,
    );
  }
}
