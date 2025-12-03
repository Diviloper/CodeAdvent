import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input = File('./input.txt').readAsLinesSync();

  first(input);
  second(input);
}

void first(List<String> input) {
  print(input.map(findMax).sum);
}

int findMax(String bank) {
  for (int i = 9; i >= 1; --i) {
    for (int j = 9; j >= 1; --j) {
      if (bank.contains(RegExp(".*$i.*$j.*"))) {
        return i * 10 + j;
      }
    }
  }
  return 11;
}

void second(List<String> input) {
  print(input.map(findMaxOverride).sum);
}

int findMaxOverride(String bank) {
  int digits = 12;
  final bankDigits = bank.split('').map(int.parse).toList();
  int number = 0;
  int start = 0;
  while (digits > 0) {
    final nextDigit = bankDigits.sublist(start, bank.length - digits + 1).max;
    start = bankDigits.indexOf(nextDigit, start) + 1;
    number = number * 10 + nextDigit;
    digits--;
  }
  return number;
}
