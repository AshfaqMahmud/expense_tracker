import 'package:flutter/material.dart';

Widget FrostedTextField({
  String? label,
  TextEditingController? controller,
  bool obscureText = false,
}) {
  return TextField(
    obscureText: obscureText,
    controller: controller,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.blue.withOpacity(0.15),
      hintText: label,
      labelStyle: TextStyle(color: Colors.black54, fontSize: 16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.3), // Light border
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.blueAccent, // Focused border color
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.3), // Enabled border color
        ),
      ),
    ),
  );
}
