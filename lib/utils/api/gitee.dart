import 'package:cotally/utils/models/user.dart';
import 'package:dio/dio.dart';

import './base_api.dart';

final dio = Dio();

class GiteeApi implements BaseRepoApi {
  @override
  String? accessToken;
  GiteeApi({this.accessToken});

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

  @override
  // https://gitee.com/api/v5/swagger#/getV5User
  Future<UserInfoModel?> checkAccessToken({required String accessToken}) async {
    final response = await dio.get("https://gitee.com/api/v5/user",
        queryParameters: {"access_token": accessToken});
    if (response.statusCode == 200) {
      return UserInfoModel.fromJson(response.data);
    }
    return null;
  }

  @override
  // https://gitee.com/api/v5/swagger#/getV5UsersUsername
  Future<UserInfoModel?> getUser({required String username}) async {
    final url = "https://gitee.com/api/v5/users/$username";
    final response = await dio.get(url);
    if (response.statusCode == 200) {
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
}
