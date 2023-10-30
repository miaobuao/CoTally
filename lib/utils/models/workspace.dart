import 'dart:io';
import 'package:cotally/utils/types.dart';

import '../config.dart';
import 'package:cotally/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'workspace.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkspaceModel {
  final String id;
  final Org org;
  List<BookModel> books;

  WorkspaceModel({
    required this.id,
    required this.org,
    required this.books,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BookModel {
  final Json data;
  final Org org;
  final String workspaceId;

  BookModel({
    required this.data,
    required this.workspaceId,
    required this.org,
  });

  String get namespace => data['namespace']['path'];
  String get name => data['name'];
  String get public => data['public'];
  String get description => data['description'] ?? '';
  String get url => data['url'];
  String get path => data['path'];

  Directory get directory {
    return Directory(join(config.basePath, org.toString(), namespace, name));
  }

  File get summaryFile {
    return File(
        join(config.basePath, org.toString(), namespace, name, 'summary'));
  }

  String get encryptedSummary => summaryFile.readAsStringSync();

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
