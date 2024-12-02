import 'dart:io';

import '../common.dart';

void main() {
  final lines = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split(' ').map(int.parse).toList())
      .toList();

  print(lines.where(isValid).length);
  print(lines.where(isValidDampened).length);
}

bool isValid(List<int> line) {
  final differences =
      line.indexed.skip(1).map((e) => e.$2 - line[e.$1 - 1]).toList();
  if (!differences.every((element) => element > 0) &&
      !differences.every((element) => element < 0)) {
    return false;
  }

  if (differences.any((element) => element.abs() < 1 || element.abs() > 3)) {
    return false;
  }
  return true;
}

bool isValidDampened(List<int> line) {
  if (isValid(line)) return true;
  for (int i = 0; i < line.length; ++i) {
    final copy = line.copy()..removeAt(i);
    if (isValid(copy)) return true;
  }
  return false;
}
