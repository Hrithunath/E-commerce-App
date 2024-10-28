import 'package:e_commerce_app/features/presentation/Widget/Home/custom_curved_edges.dart';
import 'package:flutter/material.dart';

class CustomCurvedWidget extends StatelessWidget {
  const CustomCurvedWidget({
    super.key,
    this.child,
  });
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: CustomCurvedEdges(), child: child);
  }
}
