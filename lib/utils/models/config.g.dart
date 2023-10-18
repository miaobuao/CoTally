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
      org: json['org'] as String,
      accessToken: json['accessToken'] as String,
      updateTime: DateTime.parse(json['updateTime'] as String),
    );

Map<String, dynamic> _$RemoteRepoDataToJson(RemoteRepoData instance) =>
    <String, dynamic>{
      'org': instance.org,
      'accessToken': instance.accessToken,
      'updateTime': instance.updateTime.toIso8601String(),
    };
