import "package:encrypt/encrypt.dart";
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'constants.dart';

Uint8List preparePwd(String pwd) {
  final key = utf8.encode("$pwd.$SAFE_SALT");
  final digital = sha256.convert(key);
  return Uint8List.fromList(digital.bytes);
}

(Encrypter, IV) generateEncrypter(Uint8List pwd, {String? iv}) {
  return (
    Encrypter(AES(Key(pwd), mode: AESMode.cbc)),
    iv == null ? IV.fromLength(16) : IV.fromBase64(iv),
  );
}

String encryptByPwd(String pwd, String plainText) {
  final key = preparePwd(pwd);
  final (encrypter, iv) = generateEncrypter(key);
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return "${iv.base64}.${encrypted.base64}";
}

String? decryptByPwd(String pwd, String encrypted) {
  try {
    final key = preparePwd(pwd);
    final splitted = encrypted.split(".");
    encrypted = splitted[1];
    final (encrypter, iv) = generateEncrypter(key, iv: splitted[0]);
    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
    return decrypted;
  } on Error catch (_) {
    return null;
  } on Exception catch (_) {
    return null;
  }
}
