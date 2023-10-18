import 'package:cotally/pages/home.dart';

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
          const AuthPage(),
        ),
        routerWrapper(
          '/access_token',
          AccessTokenPage(),
        ),
        routerWrapper("/home", HomePage()),
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
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.72,
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
