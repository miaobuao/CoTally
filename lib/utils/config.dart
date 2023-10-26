import 'package:hive/hive.dart';

class Config {
  Config._();
  static final Config instance = Config._();
  factory Config() => instance;

  late String basePath;
  late final BoxCollection collection;
}

final config = Config();
