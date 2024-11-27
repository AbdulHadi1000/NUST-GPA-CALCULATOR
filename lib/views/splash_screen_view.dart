import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/resources/app_colors.dart';
import 'package:nust_gpa_calculator/utils/routes/routes_name.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    Timer(const Duration(seconds: 100), () {
      Navigator.pushReplacementNamed(context, RoutesName.home);
    });
    return Scaffold(
      backgroundColor: AppColors.splashscreencolor,
      body: Center(
        child: Image.asset(
          'lib/assets/national-university-logo.png',
          width: screenWidth * 0.8,
        ),
      ),
    );
  }
}
