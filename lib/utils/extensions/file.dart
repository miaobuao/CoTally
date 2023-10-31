import 'dart:io';

extension NotExists on File {
  bool notExistsSync() {
    return !existsSync();
  }
}
