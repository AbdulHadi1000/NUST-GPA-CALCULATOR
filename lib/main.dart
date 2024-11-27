import 'package:flutter/material.dart';
import 'package:nust_gpa_calculator/data/dbHelper.dart';
import 'package:nust_gpa_calculator/data/db_provider.dart';
import 'package:nust_gpa_calculator/utils/routes/routes.dart';
import 'package:nust_gpa_calculator/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => DbProvider(dbHelper: DBHelper.getInstance()))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
