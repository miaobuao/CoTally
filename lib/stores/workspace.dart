import 'package:get/get.dart';

class WorkspaceStore {
  WorkspaceStore._internal();
  factory WorkspaceStore() => _instance;
  static final WorkspaceStore _instance = WorkspaceStore._internal();

  final count = 0.obs;
  final currentId = "".obs;
}
