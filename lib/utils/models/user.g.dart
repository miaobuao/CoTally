// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      info: UserInfoModel.fromJson(json['info'] as Map<String, dynamic>),
      org: $enumDecode(_$OrgEnumMap, json['org']),
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'info': instance.info.toJson(),
      'org': _$OrgEnumMap[instance.org]!,
      'id': instance.id,
    };

const _$OrgEnumMap = {
  Org.gitee: 'gitee',
  Org.github: 'github',
};

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
