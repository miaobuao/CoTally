// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceModel _$WorkspaceModelFromJson(Map<String, dynamic> json) =>
    WorkspaceModel(
      accessTokenId: json['accessTokenId'] as String,
      org: $enumDecode(_$OrgEnumMap, json['org']),
      books: (json['books'] as List<dynamic>)
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastOpenedBookId: json['lastOpenedBookId'] as String?,
    );

Map<String, dynamic> _$WorkspaceModelToJson(WorkspaceModel instance) =>
    <String, dynamic>{
      'org': _$OrgEnumMap[instance.org]!,
      'accessTokenId': instance.accessTokenId,
      'books': instance.books.map((e) => e.toJson()).toList(),
      'lastOpenedBookId': instance.lastOpenedBookId,
    };

const _$OrgEnumMap = {
  Org.gitee: 'gitee',
  Org.github: 'github',
};

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      namespace: json['namespace'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      public: json['public'] as bool,
      description: json['description'] as String,
      url: json['url'] as String,
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'name': instance.name,
      'namespace': instance.namespace,
      'public': instance.public,
      'description': instance.description,
      'url': instance.url,
      'path': instance.path,
      'summary': instance.summary,
    };

EncryptedBookModel _$EncryptedBookModelFromJson(Map<String, dynamic> json) =>
    EncryptedBookModel(
      namespace: json['namespace'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      public: json['public'] as bool,
      description: json['description'] as String,
      url: json['url'] as String,
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$EncryptedBookModelToJson(EncryptedBookModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'namespace': instance.namespace,
      'public': instance.public,
      'description': instance.description,
      'url': instance.url,
      'path': instance.path,
      'summary': instance.summary,
    };
