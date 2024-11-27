import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/utils/routes/routes_name.dart';
import 'package:nust_gpa_calculator/views/add_semester_view.dart';
import 'package:nust_gpa_calculator/views/homeview.dart';
import 'package:nust_gpa_calculator/views/splash_screen_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );
      case RoutesName.addSemester:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AddSemesterView(
            isUpdate: false,
          ),
        );
      // case RoutesName.gpaCalculation:
      //   return MaterialPageRoute(
      //     builder: (BuildContext context) => const GpaCalculationView(),
      //   );
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreenView(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("No Route Found"),
            ),
          ),
        );
    }
  }
}
