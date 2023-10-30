import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';

main() async {
  final algorithm = const DartArgon2id(
    parallelism: 6,
    memory: 10240,
    iterations: 4,
    hashLength: 32,
  );

  final newSecretKey = await algorithm.deriveKey(
    secretKey: SecretKey([1, 2, 3]),
    nonce: [4, 5, 6],
  );
  final newSecretKeyBytes = await newSecretKey.extractBytes();

  print('hashed password: $newSecretKeyBytes');
}
