import 'package:cotally/utils/erros.dart';
import "package:encrypt/encrypt.dart";
import 'dart:typed_data';
import 'dart:convert';
import "package:cryptography/dart.dart";
import 'package:cryptography/cryptography.dart';

const argon2id = DartArgon2id(
  parallelism: 2,
  memory: 10000,
  iterations: 2,
  hashLength: 32,
);

Future<Uint8List> kdf(String pwd) async {
  final newSecretKey = await argon2id.deriveKey(
    secretKey: SecretKey(utf8.encode(pwd)),
    nonce: utf8.encode("cc.idim.tollay"),
  );
  return Uint8List.fromList(await newSecretKey.extractBytes());
}

(Encrypter, IV) generateEncrypter(Uint8List pwd, {String? iv}) {
  return (
    Encrypter(AES(Key(pwd), mode: AESMode.cbc)),
    iv == null ? IV.fromLength(16) : IV.fromBase64(iv),
  );
}

String encryptedByDerivationKey(Uint8List key, String plain) {
  final (encrypter, iv) = generateEncrypter(key);
  final encrypted = encrypter.encrypt(plain, iv: iv);
  return "${iv.base64}.${encrypted.base64}";
}

String decryptedByDerivationKey(Uint8List key, String encrypted) {
  try {
    final splitted = encrypted.split(".");
    encrypted = splitted[1];
    final (encrypter, iv) = generateEncrypter(key, iv: splitted[0]);
    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
    return decrypted;
  } on Error catch (_) {
    throw DecyptError();
  } on Exception catch (_) {
    throw DecyptError();
  }
}

Future<String> encryptByPwd(String pwd, String plainText) async {
  final key = await kdf(pwd);
  return encryptedByDerivationKey(key, plainText);
}

Future<String> decryptByPwd(String pwd, String encrypted) async {
  final key = await kdf(pwd);
  return decryptedByDerivationKey(key, encrypted);
}

String Function(String) getDecryptFunc(Uint8List key) {
  return (String value) => decryptedByDerivationKey(key, value);
}

String Function(String) getEncryptFunc(Uint8List key) {
  return (String value) => encryptedByDerivationKey(key, value);
}
