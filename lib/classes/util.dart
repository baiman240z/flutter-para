import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'constants.dart';

class Util {
  static final Key _key = Key.fromUtf8(Constants.KEY_STR);
  static final IV _iv = IV.fromUtf8(Constants.IV_STR);
  static final AES _aes = AES(_key, mode: AESMode.cbc);

  static Uint8List decrypt(Uint8List bytes) {
    return _aes.decrypt(Encrypted(bytes), iv: _iv);
  }
}