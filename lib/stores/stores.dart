import 'workspace.dart';

class Store {
  Store._internal();
  factory Store() => _instance;
  static final Store _instance = Store._internal();

  final workspace = WorkspaceStore();
}
