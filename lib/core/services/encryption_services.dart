import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

// EncryptionServices Interface
abstract interface class EncryptionServices {
  String encrypt({required String text, required String key});
  String decrypt({required String text, required String key});
}

// CaesarCipher Implementation
class CaesarCipher implements EncryptionServices {
  @override
  String encrypt({required String text, required String key}) {
    final shift = int.tryParse(key) ?? 0;
    return _transform(text: text, shift: shift);
  }

  @override
  String decrypt({required String text, required String key}) {
    final shift = int.tryParse(key) ?? 0;
    return _transform(text: text, shift: 26 - shift);
  }

  String _transform({required String text, required int shift}) {
    final result = StringBuffer();

    for (final char in text.runes) {
      if (_isUpperCase(char)) {
        result.writeCharCode(_shiftChar(char, shift, 65));
      } else if (_isLowerCase(char)) {
        result.writeCharCode(_shiftChar(char, shift, 97));
      } else {
        result.writeCharCode(char);
      }
    }

    return result.toString();
  }

  bool _isUpperCase(int char) => char >= 65 && char <= 90;
  bool _isLowerCase(int char) => char >= 97 && char <= 122;

  int _shiftChar(int char, int shift, int base) {
    return ((char - base + shift) % 26) + base;
  }
}

// AES Implementation
class Aes implements EncryptionServices {
  @override
  String encrypt({required String text, required String key}) {
    final keyBytes =
        _padKey(Uint8List.fromList(utf8.encode(key)), 32); // 256-bit key
    final iv = Uint8List.fromList(
        List.filled(16, 0)); // Initialization vector (16 bytes for AES)

    final encrypted =
        _processAes(true, Uint8List.fromList(utf8.encode(text)), keyBytes, iv);
    return base64.encode(encrypted);
  }

  @override
  String decrypt({required String text, required String key}) {
    final keyBytes =
        _padKey(Uint8List.fromList(utf8.encode(key)), 32); // 256-bit key
    final iv = Uint8List.fromList(
        List.filled(16, 0)); // Initialization vector (16 bytes for AES)

    final decrypted = _processAes(false, base64.decode(text), keyBytes, iv);
    return utf8.decode(decrypted);
  }

  Uint8List _processAes(
      bool forEncryption, Uint8List input, Uint8List key, Uint8List iv) {
    final cipher = CBCBlockCipher(AESEngine());
    final params = PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv),
      null,
    );
    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddedCipher.init(forEncryption, params);

    return paddedCipher.process(input);
  }

  Uint8List _padKey(Uint8List key, int length) {
    if (key.length >= length) return key.sublist(0, length);
    return Uint8List.fromList([...key, ...List.filled(length - key.length, 0)]);
  }
}

// DES Implementation
class Des implements EncryptionServices {
  @override
  String encrypt({required String text, required String key}) {
    final keyBytes =
        _padKey(Uint8List.fromList(utf8.encode(key)), 8); // 64-bit key
    final iv = Uint8List.fromList(
        List.filled(8, 0)); // Initialization vector (8 bytes for DES)

    final encrypted =
        _processDes(true, Uint8List.fromList(utf8.encode(text)), keyBytes, iv);
    return base64.encode(encrypted);
  }

  @override
  String decrypt({required String text, required String key}) {
    final keyBytes =
        _padKey(Uint8List.fromList(utf8.encode(key)), 8); // 64-bit key
    final iv = Uint8List.fromList(
        List.filled(8, 0)); // Initialization vector (8 bytes for DES)

    final decrypted = _processDes(false, base64.decode(text), keyBytes, iv);
    return utf8.decode(decrypted);
  }

  Uint8List _processDes(
      bool forEncryption, Uint8List input, Uint8List key, Uint8List iv) {
    final cipher = CBCBlockCipher(AESEngine());
    final params = PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv),
      null,
    );
    final paddedCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddedCipher.init(forEncryption, params);

    return paddedCipher.process(input);
  }

  Uint8List _padKey(Uint8List key, int length) {
    if (key.length >= length) return key.sublist(0, length);
    return Uint8List.fromList([...key, ...List.filled(length - key.length, 0)]);
  }
}

// Factory for Encryption Services
enum EncryptionType { caesar, aes, des }

class EncryptionFactory {
  static EncryptionServices create(EncryptionType type) {
    switch (type) {
      case EncryptionType.caesar:
        return CaesarCipher();
      case EncryptionType.aes:
        return Aes();
      case EncryptionType.des:
        return Des();
      default:
        throw ArgumentError('Unsupported encryption type');
    }
  }
}
