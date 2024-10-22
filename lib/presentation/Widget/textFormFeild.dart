import 'package:flutter/material.dart';

class Textformfeildcustom extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  IconData prefixIcon;
  IconData sufixIcon;

  Textformfeildcustom({super.key, 
    required this.label,
    this.prefixIcon = Icons.search,
    this.sufixIcon = Icons.search,
    this.hintText,
    this.keyboardType,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 235, 233, 233))),
        hintText: hintText,
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 175, 165, 165)),
        prefixIcon: Icon(prefixIcon),
       
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
                color: Color.fromARGB(255, 192, 42, 219), width: 1.0)),
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }
}
