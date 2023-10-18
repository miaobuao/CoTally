// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteRepoConfig {
  final List<RemoteRepoData> repos;
  RemoteRepoConfig({required this.repos});
  factory RemoteRepoConfig.fromJson(Map<String, dynamic> json) =>
      _$RemoteRepoConfigFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteRepoConfigToJson(this);
}

@JsonSerializable()
class RemoteRepoData {
  final String org, accessToken, username, id;
  final DateTime updateTime;
  RemoteRepoData({
    required this.org,
    required this.accessToken,
    required this.updateTime,
    required this.username,
    required this.id,
  });
  factory RemoteRepoData.fromJson(Map<String, dynamic> json) =>
      _$RemoteRepoDataFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteRepoDataToJson(this);
}
