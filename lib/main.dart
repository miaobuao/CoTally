import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:i18n_extension/i18n_widget.dart";
import './pages/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/auth',
      getPages: [
        GetPage(name: '/auth', page: () => I18n(child: AuthPage())),
        // GetPage(name: '/main', page: () => MyHomePage(title: "title"))
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.72,
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.28,
          ),
        ),
      ),
    );
  }
}
