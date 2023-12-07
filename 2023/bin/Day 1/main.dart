import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input = File('./bin/Day 1/input.txt').readAsLinesSync();

  print(input.map(getCalibrationValue).sum);
  print(input.map(replaceTextNumbers).map(getCalibrationValue).sum);
}

int getCalibrationValue(String line) {
  final parts = line.split('').map(int.tryParse).whereType<int>();
  return parts.first * 10 + parts.last;
}

String replaceTextNumbers(String line) => line
    .replaceAll('one', 'one1one')
    .replaceAll('two', 'two2two')
    .replaceAll('three', 'three3three')
    .replaceAll('four', 'four4four')
    .replaceAll('five', 'five5five')
    .replaceAll('six', 'six6six')
    .replaceAll('seven', 'seven7seven')
    .replaceAll('eight', 'eight8eight')
    .replaceAll('nine', 'nine9nine');
