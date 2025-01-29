import 'package:campuslink/screens/home.dart';
import 'package:campuslink/screens/initial_loading.dart';
import 'package:campuslink/screens/login.dart';
import 'package:campuslink/styles/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF155EEF),
            primary: Color.fromARGB(255, 6, 72, 133)),
        fontFamily: 'Nexa',
        textTheme: kTextThemeData,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const InitialLoadingScreen(),
        '/login': (BuildContext context) => const LoginScreen(),
        '/home': (BuildContext context) => const HomeScreen()
      },
    );
  }
}
