// ignore: depend_on_referenced_packages
import 'package:cotally/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final UserInfo info;
  Org org;
  String id;

  User({required this.info, required this.org, required this.id});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserInfo {
  final String name;

  @JsonKey(name: "avatar_url")
  final String avatarUrl;

  final int id;

  UserInfo({required this.avatarUrl, required this.name, required this.id});
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
