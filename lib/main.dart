import 'package:cotally/style/colors.dart';

import 'component/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:i18n_extension/i18n_widget.dart";
import 'package:path_provider/path_provider.dart';
import 'pages/access_token.dart';
import 'pages/auth.dart';
import 'utils/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final basePath = await getApplicationDocumentsDirectory();
  final db = DB();
  db.basePath = basePath.path;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/auth',
      getPages: [
        routerWrapper(
          '/auth',
          AuthPage(),
        ),
        routerWrapper(
          '/access_token',
          AccessTokenPage(),
        ),
      ],
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: primaryMaterialColor.shade900,
        ),
        useMaterial3: true,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryMaterialColor),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.72,
          ),
        ),
        primaryColor: primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.pressed)
                    ? primaryMaterialColor.shade500
                    : primaryMaterialColor.shade400),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: MaterialStateBorderSide.resolveWith((states) {
              Color sidecolor;
              if (states.contains(MaterialState.disabled)) {
                sidecolor = secondaryMaterialColor.shade100;
              } else {
                sidecolor = secondaryMaterialColor.shade800;
              }
              return BorderSide(color: sidecolor, width: 2);
            }),
            foregroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return secondaryMaterialColor.shade100;
              } else {
                return secondaryMaterialColor.shade800;
              }
            }),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return secondaryMaterialColor.shade100;
              } else {
                return secondaryMaterialColor.shade800;
              }
            }),
          ),
        ),
      ),
    );
  }
}

dynamic routerWrapper(String name, Widget page) {
  return GetPage(
      name: name,
      page: () => I18n(
              child: ToastPage(
            child: page,
          )));
}
