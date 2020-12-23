import 'dart:convert';

import 'package:crypto/crypto.dart';

void main() {
  // first();
  second();
}

void first() {
  final id = 'ojvtpuvg';
  String password = '';
  int i = 0;
  while (password.length < 8) {
    final hash = md5.convert(utf8.encode('$id$i')).toString();
    if (hash.startsWith('00000')) {
      password += hash.split('')[5];
      print(password);
    }
    ++i;
  }
  print(password);
}

void second() {
  final id = 'ojvtpuvg';
  final password = List<String>.filled(8, '_');
  int i = 0;
  bool found = false;
  print(password.join());
  while (!found) {
    final hash = md5.convert(utf8.encode('$id$i')).toString();
    if (hash.startsWith('00000')) {
      final splitted = hash.split('');
      int index = int.tryParse(splitted[5])?? -1;
      if (index >= 0 && index < 8 && password[index] == '_') {
        password[int.parse(splitted[5])] = splitted[6];
        found = !password.contains('_');
        print(password.join());
      }
    }
    ++i;
  }
  print(password.join());
}
