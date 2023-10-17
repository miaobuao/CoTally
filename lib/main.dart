import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:i18n_extension/i18n_widget.dart";
import 'package:path_provider/path_provider.dart';
import 'pages/AccessToken.dart';
import "pages/Auth.dart";
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
        GetPage(
          name: '/auth',
          page: () => I18n(child: AuthPage()),
        ),
        GetPage(
          name: '/access_token',
          page: () => I18n(child: AccessTokenPage()),
        ),
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
