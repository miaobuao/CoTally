import 'package:cotally/utils/erros.dart';
import "package:encrypt/encrypt.dart";
import 'dart:typed_data';
import 'dart:convert';
import "package:cryptography/dart.dart";
import 'package:cryptography/cryptography.dart';

const argon2id = DartArgon2id(
  parallelism: 4,
  memory: 10240,
  iterations: 4,
  hashLength: 32,
);

Future<List<int>> kdf(String pwd) async {
  final newSecretKey = await argon2id.deriveKey(
    secretKey: SecretKey(utf8.encode(pwd)),
    nonce: utf8.encode("cc.idim.tollay"),
  );
  return await newSecretKey.extractBytes();
}

Future<Uint8List> preparePwd(String pwd) async {
  final hashed = await kdf(pwd);
  return Uint8List.fromList(hashed);
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
  final key = await preparePwd(pwd);
  return encryptedByDerivationKey(key, plainText);
}

Future<String> decryptByPwd(String pwd, String encrypted) async {
  final key = await preparePwd(pwd);
  return decryptedByDerivationKey(key, encrypted);
}
