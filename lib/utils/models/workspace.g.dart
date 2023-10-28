// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceModel _$WorkspaceModelFromJson(Map<String, dynamic> json) =>
    WorkspaceModel(
      id: json['id'] as String,
      org: $enumDecode(_$OrgEnumMap, json['org']),
      books: (json['books'] as List<dynamic>)
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkspaceModelToJson(WorkspaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org': _$OrgEnumMap[instance.org]!,
      'books': instance.books.map((e) => e.toJson()).toList(),
    };

const _$OrgEnumMap = {
  Org.gitee: 'gitee',
  Org.github: 'github',
};

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      data: json['data'] as Map<String, dynamic>,
      workspaceId: json['workspaceId'] as String,
      org: $enumDecode(_$OrgEnumMap, json['org']),
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'data': instance.data,
      'org': _$OrgEnumMap[instance.org]!,
      'workspaceId': instance.workspaceId,
    };
