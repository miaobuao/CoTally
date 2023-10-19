// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteRepoConfig _$RemoteRepoConfigFromJson(Map<String, dynamic> json) =>
    RemoteRepoConfig(
      repos: (json['repos'] as List<dynamic>)
          .map((e) => RemoteRepoData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RemoteRepoConfigToJson(RemoteRepoConfig instance) =>
    <String, dynamic>{
      'repos': instance.repos.map((e) => e.toJson()).toList(),
    };

RemoteRepoData _$RemoteRepoDataFromJson(Map<String, dynamic> json) =>
    RemoteRepoData(
      org: $enumDecode(_$OrgEnumMap, json['org']),
      accessToken: json['accessToken'] as String,
      updateTime: DateTime.parse(json['updateTime'] as String),
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
    );

Map<String, dynamic> _$RemoteRepoDataToJson(RemoteRepoData instance) =>
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
