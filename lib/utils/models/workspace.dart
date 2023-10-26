import 'package:cotally/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workspace.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkspaceModel {
  final Org org;
  final String id;
  List<EncryptedBookModel> books;
  String? lastOpenedBookId;

  WorkspaceModel({
    required this.id,
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
  String? description;
  String url;
  String path;
  String? summary;

  BookModel({
    required this.namespace,
    required this.name,
    required this.path,
    required this.public,
    required this.description,
    required this.url,
    this.summary,
  });

  EncryptedBookModel encrypt(String Function(String) encrypt) {
    return EncryptedBookModel(
      namespace: namespace,
      name: name,
      path: path,
      public: public,
      description: description == null ? null : encrypt(description as String),
      summary: summary == null ? null : encrypt(summary ?? ''),
      url: url,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EncryptedBookModel extends BookModel {
  EncryptedBookModel({
    required super.namespace,
    required super.name,
    required super.path,
    required super.public,
    required super.description,
    required super.url,
    super.summary,
  });

  BookModel decrypt(String Function(String) decrypt) {
    return BookModel(
      namespace: namespace,
      name: name,
      path: path,
      public: public,
      description: description == null ? null : decrypt(description as String),
      summary: summary == null ? null : decrypt(summary as String),
      url: url,
    );
  }

  factory EncryptedBookModel.fromJson(Map<String, dynamic> json) =>
      _$EncryptedBookModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$EncryptedBookModelToJson(this);
}
