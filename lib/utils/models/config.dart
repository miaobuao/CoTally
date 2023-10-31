import 'dart:typed_data';

import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/crypto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(explicitToJson: true)
class RemoteRepoConfigModel {
  final List<RemoteRepoDataModel> repos;
  String? lastOpenedId;
  RemoteRepoConfigModel({required this.repos, this.lastOpenedId});
  factory RemoteRepoConfigModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteRepoConfigModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteRepoConfigModelToJson(this);
}

@JsonSerializable()
class RemoteRepoDataModel {
  final String accessToken;
  final String id;
  final Org org;
  final DateTime updateTime;
  final String ownerId;
  RemoteRepoDataModel({
    required this.id,
    required this.org,
    required this.accessToken,
    required this.updateTime,
    required this.ownerId,
  });

  factory RemoteRepoDataModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteRepoDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteRepoDataModelToJson(this);
}

@JsonSerializable()
class EncryptedRemoteRepoDataModel extends RemoteRepoDataModel {
  EncryptedRemoteRepoDataModel({
    required super.id,
    required super.org,
    required super.accessToken,
    required super.updateTime,
    required super.ownerId,
  });

  DecryptedRemoteRepoDataModel decrypt(Uint8List dk) {
    final decryptFunc = getDecryptFunc(dk);
    return DecryptedRemoteRepoDataModel(
      id: id,
      org: org,
      accessToken: decryptFunc(accessToken),
      updateTime: updateTime,
      ownerId: ownerId,
    );
  }

  factory EncryptedRemoteRepoDataModel.fromJson(Map<String, dynamic> json) =>
      _$EncryptedRemoteRepoDataModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$EncryptedRemoteRepoDataModelToJson(this);
}

@JsonSerializable()
class DecryptedRemoteRepoDataModel extends RemoteRepoDataModel {
  DecryptedRemoteRepoDataModel({
    required super.id,
    required super.org,
    required super.accessToken,
    required super.updateTime,
    required super.ownerId,
  });

  EncryptedRemoteRepoDataModel encrypt(String Function(String) encryptFunc) {
    return EncryptedRemoteRepoDataModel(
      id: id,
      org: org,
      accessToken: encryptFunc(accessToken),
      updateTime: updateTime,
      ownerId: ownerId,
    );
  }

  factory DecryptedRemoteRepoDataModel.fromJson(Map<String, dynamic> json) =>
      _$DecryptedRemoteRepoDataModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DecryptedRemoteRepoDataModelToJson(this);
}
