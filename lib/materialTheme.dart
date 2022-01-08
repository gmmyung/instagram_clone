import 'package:flutter/material.dart';

const lightModeBorderColor = Color(0xffdbdbdb);
const darkModeBorderColor = Color(0xff222222);

ThemeData? materialAppLightTheme() {
  return ThemeData(
      textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
          bodyText2: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.black, fontSize: 14)),
      splashFactory: NoSplash.splashFactory,
      dividerColor: lightModeBorderColor,
      iconTheme: const IconThemeData(color: Colors.black),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.black, fontSize: 20),
          shape:
              Border(bottom: BorderSide(color: lightModeBorderColor, width: 1)),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black, size: 30),
          backgroundColor: Colors.white,
          actionsIconTheme: IconThemeData(color: Colors.black)),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color: Colors.black, size: 25),
        unselectedIconTheme: IconThemeData(color: Colors.black, size: 25),
        elevation: 0,
        backgroundColor: Colors.white,
      ));
}

ThemeData? materialAppDarkTheme() {
  return ThemeData(
      textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
          bodyText2: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.white, fontSize: 14)),
      splashFactory: NoSplash.splashFactory,
      dividerColor: darkModeBorderColor,
      iconTheme: const IconThemeData(color: Colors.white),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.white, fontSize: 20),
          shape:
              Border(bottom: BorderSide(color: darkModeBorderColor, width: 1)),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white, size: 30),
          backgroundColor: Colors.black,
          actionsIconTheme: IconThemeData(color: Colors.white)),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color: Colors.white, size: 25),
        unselectedIconTheme: IconThemeData(color: Colors.white, size: 25),
        elevation: 0,
        backgroundColor: Colors.black,
      ));
}
