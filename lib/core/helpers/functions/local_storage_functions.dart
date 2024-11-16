import 'dart:io';

Future<void> deleteImageFromFileSystem(File file) async {
  if (await file.exists()) {
    await file.delete();
  }
}

String encryptNote(String text, int shift) {
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

String decryptNote(String text, int shift) {
  return encryptNote(text, 26 - shift);
}
