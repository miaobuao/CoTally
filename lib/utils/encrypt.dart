import "package:encrypt/encrypt.dart";
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';

Uint8List preparePwd(String pwd) {
  final key = utf8.encode("$pwd.idim.cc");
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

String decryptByPwd(String pwd, String encrypted) {
  final key = preparePwd(pwd);
  final splitted = encrypted.split(".");
  encrypted = splitted[1];
  final (encrypter, iv) = generateEncrypter(key, iv: splitted[0]);
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
  return decrypted;
}
