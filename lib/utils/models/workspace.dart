import 'package:cotally/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workspace.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkspaceModel {
  final Org org;
  final String accessTokenId;

  WorkspaceModel({
    required this.accessTokenId,
    required this.org,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);
}
