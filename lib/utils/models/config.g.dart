// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteRepoConfigModel _$RemoteRepoConfigModelFromJson(
        Map<String, dynamic> json) =>
    RemoteRepoConfigModel(
      repos: (json['repos'] as List<dynamic>)
          .map((e) => RemoteRepoDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastOpenedId: json['lastOpenedId'] as String?,
    );

Map<String, dynamic> _$RemoteRepoConfigModelToJson(
        RemoteRepoConfigModel instance) =>
    <String, dynamic>{
      'repos': instance.repos.map((e) => e.toJson()).toList(),
      'lastOpenedId': instance.lastOpenedId,
    };

RemoteRepoDataModel _$RemoteRepoDataModelFromJson(Map<String, dynamic> json) =>
    RemoteRepoDataModel(
      id: json['id'] as String,
      org: $enumDecode(_$OrgEnumMap, json['org']),
      accessToken: json['accessToken'] as String,
      updateTime: DateTime.parse(json['updateTime'] as String),
      ownerId: json['ownerId'] as String,
    );

Map<String, dynamic> _$RemoteRepoDataModelToJson(
        RemoteRepoDataModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'id': instance.id,
      'org': _$OrgEnumMap[instance.org]!,
      'updateTime': instance.updateTime.toIso8601String(),
      'ownerId': instance.ownerId,
    };

const _$OrgEnumMap = {
  Org.gitee: 'gitee',
  Org.github: 'github',
};

EncryptedRemoteRepoDataModel _$EncryptedRemoteRepoDataModelFromJson(
        Map<String, dynamic> json) =>
    EncryptedRemoteRepoDataModel(
      id: json['id'] as String,
      org: $enumDecode(_$OrgEnumMap, json['org']),
      accessToken: json['accessToken'] as String,
      updateTime: DateTime.parse(json['updateTime'] as String),
      ownerId: json['ownerId'] as String,
    );

Map<String, dynamic> _$EncryptedRemoteRepoDataModelToJson(
        EncryptedRemoteRepoDataModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'id': instance.id,
      'org': _$OrgEnumMap[instance.org]!,
      'updateTime': instance.updateTime.toIso8601String(),
      'ownerId': instance.ownerId,
    };
