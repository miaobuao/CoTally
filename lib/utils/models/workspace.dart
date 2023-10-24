import 'package:cotally/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workspace.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkspaceModel {
  final Org org;
  final String accessTokenId;
  List<BookModel> books;
  String? lastOpenedBookId;

  WorkspaceModel({
    required this.accessTokenId,
    required this.org,
    required this.books,
    this.lastOpenedBookId,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BookModel {
  final String name;
  final String namespace;
  final bool public;
  String description;
  String url;

  BookModel({
    required this.namespace,
    required this.name,
    required this.public,
    required this.description,
    required this.url,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
