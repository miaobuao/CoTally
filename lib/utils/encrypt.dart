import "package:encrypt/encrypt.dart";
import 'dart:typed_data';

(Encrypter, IV) generateEncrypter(Uint8List pwd, {String? iv}) {
  return (
    Encrypter(AES(Key(pwd), mode: AESMode.cbc)),
    iv == null ? IV.fromLength(16) : IV.fromBase64(iv),
  );
}

String encryptByPwd(Uint8List pwd, String plainText) {
  final (encrypter, iv) = generateEncrypter(pwd);
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return "${iv.base64}.${encrypted.base64}";
}

String decryptByPwd(Uint8List pwd, String encrypted) {
  final splitted = encrypted.split(".");
  encrypted = splitted[1];
  final (encrypter, iv) = generateEncrypter(pwd, iv: splitted[0]);
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
  return decrypted;
}
