import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  final key = 'ckczppom';
  int current = 1;
  while (!generateMd5('$key$current').startsWith('000000')) {
    current++;
  }
  print(current);
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
