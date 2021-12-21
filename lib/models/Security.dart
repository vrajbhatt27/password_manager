import 'package:encrypt/encrypt.dart' as crypto;
import 'package:test_app/models/FileHandler.dart';

// If not present creates new file key.pem and sets a key. If file is present then used to set new key.
Future<bool> createFile() async {
  final key = crypto.Key.fromUtf8('#E6@O`Xp9fD4T(,!^"w:l!V81sMFca2l');
  final iv = crypto.IV.fromLength(16);

  Map<String, dynamic> data = {'key': key.base64, 'iv': iv.base64};

  FileHandler fh = FileHandler('data.json');
  await fh.write2File(data);
  return true;
}

// Encrypts the given password
Future encrypt(String pwd) async {
  FileHandler fh = FileHandler('data.json');

  Map<String, dynamic> data = await fh.readFile();

  if (data.isEmpty) {
    await createFile();
  }

  data = await fh.readFile();

  print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  print(data);
  print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

  final key = crypto.Key.fromBase64(data['key']);
  final iv = crypto.IV.fromBase64(data['iv']);

  final encryptor = crypto.Encrypter(crypto.AES(key));

  String cipher = encryptor.encrypt(pwd, iv: iv).base64;
  print(cipher);
  return cipher;
}

// Decrypts the given password
Future decrypt(String cipher) async {
  FileHandler fh = FileHandler('data.json');

  Map<String, dynamic> data = await fh.readFile();

  final key = crypto.Key.fromBase64(data['key']);
  final iv = crypto.IV.fromBase64(data['iv']);

  final encryptor = crypto.Encrypter(crypto.AES(key));

  crypto.Encrypted e = crypto.Encrypted.fromBase64(cipher);

  String pwd = encryptor.decrypt(e, iv: iv);
  print(pwd);
  return pwd;
}

Future<String> encryptMsg(String msg) async {
  final key =
      crypto.Key.fromBase64("I0U2QE9gWHA5ZkQ0VCgsIV4idzpsIVY4MXNNRmNhMmw=");
  final iv = crypto.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
  final encryptor = crypto.Encrypter(crypto.AES(key));
  String cipher = encryptor.encrypt(msg, iv: iv).base64;
  return cipher;
}

Future<String> decryptMsg(String cipher) async {
  final key =
      crypto.Key.fromBase64("I0U2QE9gWHA5ZkQ0VCgsIV4idzpsIVY4MXNNRmNhMmw=");
  final iv = crypto.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
  final encryptor = crypto.Encrypter(crypto.AES(key));
  crypto.Encrypted e = crypto.Encrypted.fromBase64(cipher);
  String msg = encryptor.decrypt(e, iv: iv);
  return msg;
}
