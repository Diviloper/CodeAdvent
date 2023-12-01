import 'dart:io';

void main() {
  final input = File('./bin/Day 1/input.txt').readAsLinesSync();
  print(getCalibration(input));
  print(getCalibration(replaceTextNumbers(input).toList()));
}

int getCalibration(List<String> lines) {
  return lines
      .map((e) => e.split('').map(int.tryParse).whereType<int>().toList())
      .map((e) => e.first * 10 + e.last)
      .reduce((value, element) => value + element);
}

Iterable<String> replaceTextNumbers(List<String> lines) => lines.map((e) => e
    .replaceAll('one', 'one1one')
    .replaceAll('two', 'two2two')
    .replaceAll('three', 'three3three')
    .replaceAll('four', 'four4four')
    .replaceAll('five', 'five5five')
    .replaceAll('six', 'six6six')
    .replaceAll('seven', 'seven7seven')
    .replaceAll('eight', 'eight8eight')
    .replaceAll('nine', 'nine9nine'));
