import 'dart:io';
import 'package:dart_git/config.dart';
import 'package:dart_git/dart_git.dart';
import 'package:git_bindings/git_bindings.dart' as gb;
import 'package:rw_git/rw_git.dart';

final rw = RwGit();

class Git {
  late final GitRepository repo;
  final String path;
  final String url;

  Git({
    required this.path,
    required this.repo,
    required this.url,
  });

  static Future<Git> clone(String url, String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final created = await rw.clone(path, url);
    if (created) {
      final repo = GitRepository.load(path);
      return Git(path: path, url: url, repo: repo.data!);
    }
    throw Exception();
  }

  Result<void> addAll() {
    return add('.');
  }

  Result<void> add(String path) {
    return repo.add(path);
  }

  Result<GitCommit> commit(String msg, String author, String email) {
    return repo.commit(
      message: msg,
      author: GitAuthor(name: author, email: email),
    );
  }

  Result<BranchConfig?> push({
    required String name,
    required String url,
    required String fetch,
    required String remoteBranchName,
  }) {
    return repo.setUpstreamTo(
      GitRemoteConfig(name: name, url: url, fetch: fetch),
      remoteBranchName,
    );
  }
}
