import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final lines = File('./bin/Day 4/input.txt').readAsLinesSync();

  print(lines.map(getNumbers).zippedMap(getPoints).sum);

  print(getNumberOfScratchcards(lines));
}

(Set<String> winning, Set<String> owned) getNumbers(String card) {
  final [win, own] = card.split(': ').last.split(' | ');
  return (
    win.split(' ').toSet()..remove(''),
    own.split(' ').toSet()..remove('')
  );
}

int getPoints(Set<String> winning, Set<String> owned) {
  final count = winning.intersection(owned).length;
  if (count == 0) return 0;
  return pow(2, count - 1).toInt();
}

int getNumMatchingNumbers(Set<String> winning, Set<String> owned) {
  return winning.intersection(owned).length;
}

int getNumberOfScratchcards(List<String> lines) {
  final copies = List.filled(lines.length, 1);
  final points = lines.map(getNumbers).zippedMap(getNumMatchingNumbers);
  for (final (i, point) in points.indexed) {
    for (int j = 1; j <= point && i + j < copies.length; ++j) {
      copies[i + j] += copies[i];
    }
  }
  return copies.sum;
}
