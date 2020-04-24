import 'package:eventapp/routes.dart';
import 'package:eventapp/screens/splash/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Lato'),
      onGenerateRoute: AppRoutes.generateRoute,
      home: SplashPage(),
    );
  }
}
