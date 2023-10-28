import 'dart:async';
import 'dart:convert';

import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import './base_api.dart';

final dio = Dio();

class GiteeApi implements BaseRepoApi {
  @override
  String? accessToken;
  final org = Org.gitee;
  GiteeApi({this.accessToken});

  static const String base = "https://gitee.com/api/v5";

  @override
  addCollaborator({
    required String owner,
    required String repo,
    required String username,
    required RepoPermission permission,
  }) {
    // TODO: implement addCollaborator
    throw UnimplementedError();
  }

  // https://gitee.com/api/v5/swagger#/getV5User
  @override
  Future<UserInfoModel?> checkAccessToken({required String accessToken}) async {
    final response = await dio.get(
      "$base/user",
      queryParameters: {
        "access_token": accessToken,
      },
    );
    if (isSuccessCode(response.statusCode)) {
      return UserInfoModel(data: response.data);
    }
    return null;
  }

  // https://gitee.com/api/v5/swagger#/getV5UsersUsername
  @override
  Future<UserInfoModel?> getUser({required String username}) async {
    final url = "$base/users/$username";
    final response = await dio.get(url);
    if (isSuccessCode(response.statusCode)) {
      return UserInfoModel.fromJson(response.data);
    }
    return null;
  }

  @override
  Future<List<UserInfoModel>> listCollaborators({
    required String owner,
    required String repo,
    int? page,
    int? perPage,
  }) {
    // TODO: implement listCollaborators
    throw UnimplementedError();
  }

  @override
  removeCollaborator({
    required String owner,
    required String repo,
    required String username,
  }) {
    // TODO: implement removeCollaborator
    throw UnimplementedError();
  }

  // https://gitee.com/api/v5/swagger#/getV5UserRepos
  @override
  Future<List<BookModel>?> listRepos({
    required String workspaceId,
    int page = 1,
    int perPage = 100,
  }) async {
    const url = "$base/user/repos";
    final response = await dio.get(url, queryParameters: {
      "access_token": accessToken,
      "page": page,
      "per_page": perPage,
      "visibility": 'all',
    });
    if (isSuccessCode(response.statusCode)) {
      return List.from(response.data.map((data) => parseBook(
            data: data,
            org: org,
            workspaceId: workspaceId,
          )));
    }
    return null;
  }

  // https://gitee.com/api/v5/swagger#/postV5UserRepos
  @override
  Future<BookModel?> createRepo({
    required String name,
    required String description,
    required String summary,
    required bool public,
    required String workspaceId,
  }) async {
    const url = "$base/user/repos";
    return await dio.post(url, data: {
      "access_token": accessToken,
      'name': name,
      "description": description,
      "license_template": "MIT",
    }).then((response) async {
      final data = response.data;
      if (!response.statusCode.toString().startsWith("20") || data == null) {
        return null;
      }
      final book = parseBook(
        data: data,
        org: org,
        workspaceId: workspaceId,
      );
      if (await createFile(
            namespace: book.namespace,
            path: book.path,
            filePath: 'summary',
            content: summary,
            message: DateTime.now().toString(),
          ) &&
          public) {
        return await updateRepoSettings(
            book: book, private: false, workspaceId: workspaceId);
      }
      return book;
    });
  }

  // https://gitee.com/api/v5/swagger#/patchV5ReposOwnerRepo
  @override
  Future<BookModel?> updateRepoSettings({
    required BookModel book,
    bool? private,
    String? description,
    required String workspaceId,
  }) async {
    final url = "https://gitee.com/api/v5/repos/${book.namespace}/${book.path}";
    final Map<String, dynamic> data = {
      "access_token": accessToken,
      "name": book.name,
    };
    if (private != null) {
      data['private'] = private;
    }
    if (description != null) {
      data['description'] = description;
    }
    return await dio
        .patch(url, data: data)
        .then((value) => isSuccessCode(value.statusCode)
            ? parseBook(
                data: value.data,
                org: org,
                workspaceId: workspaceId,
              )
            : null);
  }

  @override
  // https://gitee.com/api/v5/swagger#/postV5ReposOwnerRepoContentsPath
  Future<bool> createFile({
    required String namespace,
    required String path,
    required String filePath,
    required String content,
    required String message,
  }) async {
    final url = join("$base/repos/$namespace/$path/contents", filePath);
    return await dio.post(url, data: {
      "access_token": accessToken,
      "message": message,
      'content': base64.encode(utf8.encode(content)),
    }).then((value) => value.statusCode == 200);
  }

  @override
  // https://gitee.com/api/v5/swagger#/deleteV5ReposOwnerRepo
  Future<bool> deleteRepo({
    required String namespace,
    required String path,
  }) async {
    final url = "$base/repos/$namespace/$path";
    return await dio.delete(url, data: {
      "access_token": accessToken,
    }).then((value) => isSuccessCode(value.statusCode));
  }

  @override
  String cloneUrl(String namespace, String path) {
    return "https://oauth2:$accessToken@gitee.com/$namespace/$path.git";
  }
}

BookModel parseBook({
  required dynamic data,
  required Org org,
  required String workspaceId,
}) {
  return BookModel(
    // namespace: data['namespace']['path'],
    // name: data['name'],
    // public: data['public'],
    // description: data['description'] ?? '',
    // url: data['url'],
    // path: data['path'],
    workspaceId: workspaceId,
    org: org,
    data: data,
  );
}

bool isSuccessCode(int? code) {
  return code.toString().startsWith("20");
}
