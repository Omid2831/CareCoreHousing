import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/authentication/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareCoreHousing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F6FFF)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
