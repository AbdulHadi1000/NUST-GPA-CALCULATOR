import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/resources/app_colors.dart';

class RoundButtons extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onpress;
  const RoundButtons(
      {super.key, required this.buttonTitle, required this.onpress});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: onpress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.buttoncolor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01, // Responsive padding
              horizontal: screenWidth * 0.05),
          child: Text(
            buttonTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
