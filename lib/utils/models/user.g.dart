// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      info: UserInfo.fromJson(json['info'] as Map<String, dynamic>),
      org: $enumDecode(_$OrgEnumMap, json['org']),
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'info': instance.info.toJson(),
      'org': _$OrgEnumMap[instance.org]!,
      'id': instance.id,
    };

const _$OrgEnumMap = {
  Org.gitee: 'gitee',
  Org.github: 'github',
};

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      avatarUrl: json['avatar_url'] as String,
      name: json['name'] as String,
      id: json['id'] as int,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'id': instance.id,
    };
