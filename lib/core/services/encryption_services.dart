abstract interface class EncryptionServices {
  String encrypt({required String text, required int shift});
  String decrypt({required String text, required int shift});
}

class CaesarCipher implements EncryptionServices {
  @override
  String encrypt({required String text, required int shift}) {
    String res = '';

    for (int i = 0; i < text.length; i++) {
      int ascii = text.codeUnitAt(i);

      if (ascii >= 65 && ascii <= 90) {
        int shiftedCode = ((ascii - 65 + shift) % 26) + 65;
        res += String.fromCharCode(shiftedCode);
      } else if (ascii >= 97 && ascii <= 122) {
        int shiftedCode = ((ascii - 97 + shift) % 26) + 97;
        res += String.fromCharCode(shiftedCode);
      } else {
        res += text[i];
      }
    }

    return res;
  }

  @override
  String decrypt({required String text, required int shift}) {
    return encrypt(text: text, shift: 26 - shift);
  }
}
