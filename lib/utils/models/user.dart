import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  final UserInfoModel info;
  Org org;
  String id;

  UserModel({required this.info, required this.org, required this.id});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserInfoModel {
  final Json data;
  String get name => data['name'];
  String get login => data['login'];
  String get avatarUrl => data['avatar_url'];

  UserInfoModel({
    required this.data,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
