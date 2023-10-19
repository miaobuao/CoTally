import 'package:cotally/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workspace.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkspaceModel {
  final Org org;
  final List<String> collaborators;

  WorkspaceModel({
    required this.org,
    required this.collaborators,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);
}
