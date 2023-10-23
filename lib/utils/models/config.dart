import 'package:cotally/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteRepoConfigModel {
  final List<RemoteRepoDataModel> repos;
  String? lastOpenedId;
  RemoteRepoConfigModel({required this.repos, this.lastOpenedId});
  factory RemoteRepoConfigModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteRepoConfigModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteRepoConfigModelToJson(this);
}

@JsonSerializable()
class RemoteRepoDataModel {
  final String accessToken;
  final String id;
  final Org org;
  final DateTime updateTime;
  final String ownerId;
  RemoteRepoDataModel({
    required this.org,
    required this.accessToken,
    required this.updateTime,
    required this.id,
    required this.ownerId,
  });
  factory RemoteRepoDataModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteRepoDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteRepoDataModelToJson(this);
}
