import 'package:flutter/material.dart';

class Textformfield extends StatelessWidget {
  final TextEditingController? titlecontroler;
  final String hintText;
  const Textformfield({super.key, required this.hintText, this.titlecontroler});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titlecontroler,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText, // Adds a floating label
        prefixIcon: const Icon(Icons.book), // Icon for the input field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: const BorderSide(
            color: Colors.grey, // Border color
            width: 1.5, // Border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue, // Color when focused
            width: 2, // Width when focused
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300, // Color when enabled
            width: 1.5,
          ),
        ),
        hintStyle:
            TextStyle(color: Colors.grey.shade400), // Style for hint text
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 10), // Padding inside the field
      ),
    );
  }
}
