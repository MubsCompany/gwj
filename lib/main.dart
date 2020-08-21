import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template/routes.dart';
import 'package:template/utils/uidata.dart';
import 'package:pigment/pigment.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor primaryColor = MaterialColor(
          UIData.darkPrimaryColor.value,
          <int, Color>{
            50: UIData.darkPrimaryColor,
            100: UIData.darkPrimaryColor,
            200: UIData.darkPrimaryColor,
            300: UIData.darkPrimaryColor,
            350: UIData.darkPrimaryColor, // only for raised button while pressed in light theme
            400: UIData.darkPrimaryColor,
            500: UIData.darkPrimaryColor,
            600: UIData.darkPrimaryColor,
            700: UIData.darkPrimaryColor,
            800: UIData.darkPrimaryColor,
            850: UIData.darkPrimaryColor, // only for background color in dark theme
            900: UIData.darkPrimaryColor,
          },
        );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: UIData.appName,
      routes: routes,
      theme: ThemeData(
        fontFamily: 'futura',
        primarySwatch: primaryColor,
        appBarTheme: AppBarTheme(
          color: UIData.primaryColor
        ),
        cursorColor: UIData.darkPrimaryColor,
        primaryTextTheme: TextTheme(
          overline: TextStyle(color: UIData.darkPrimaryColor),
        )
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
