import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final patterns = File('./bin/Day 13/input.txt')
      .readAsStringSync()
      .split('\n\n')
      .map((e) => e.split('\n'))
      .toList();

  print(patterns
      .map((e) => (getHorizontalReflection(e), getVerticalReflection(e)))
      .zippedMap((h, v) => h * 100 + v)
      .sum);

  print(patterns
      .map((e) => (
            getSmudgedHorizontalReflection(e),
            getSmudgedVerticalReflection(e),
          ))
      .zippedMap((h, v) => h * 100 + v)
      .sum);
}

int getHorizontalReflection(List<String> pattern, [int? skip]) {
  for (int i = 1; i < pattern.length; ++i) {
    if (i == skip) continue;
    if (isHorizontallySymmetric(pattern, i)) {
      return i;
    }
  }
  return 0;
}

bool isHorizontallySymmetric(List<String> pattern, int line) {
  for (int i = 0; line - i - 1 >= 0 && line + i < pattern.length; ++i) {
    if (pattern[line - i - 1] != pattern[line + i]) {
      return false;
    }
  }
  return true;
}

int getVerticalReflection(List<String> pattern) {
  return getHorizontalReflection(pattern
      .map((e) => e.split(''))
      .toList()
      .transpose()
      .map((e) => e.join())
      .toList());
}

int? singleDifference(String first, String second) {
  int? diffIndex;
  for (final ((i, f), s) in zip(first.split('').indexed, second.split(''))) {
    if (f == s) continue;
    if (diffIndex != null) return null;
    diffIndex = i;
  }
  return diffIndex;
}

int getSmudgedHorizontalReflection(List<String> pattern) {
  final previousLine = getHorizontalReflection(pattern);
  for (final (f, s) in range(pattern.length).toList().triangularProduct()) {
    final diff = singleDifference(pattern[f], pattern[s]);
    if (diff == null) continue;
    final oldLine = pattern[f];
    final newLine = pattern[f].split('');
    newLine[diff] = newLine[diff] == '.' ? '#' : '.';
    pattern[f] = newLine.join();
    final newReflection = getHorizontalReflection(pattern, previousLine);
    pattern[f] = oldLine;
    if (newReflection != 0) {
      return newReflection;
    }
  }
  return 0;
}

int getSmudgedVerticalReflection(List<String> pattern) {
  return getSmudgedHorizontalReflection(pattern
      .map((e) => e.split(''))
      .toList()
      .transpose()
      .map((e) => e.join())
      .toList());
}
