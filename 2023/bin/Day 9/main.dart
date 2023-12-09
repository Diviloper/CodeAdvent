import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

extension on Iterable<int> {
  int get diff => reduce((previousValue, element) => element - previousValue);
}

void main() {
  final readings = File('./bin/Day 9/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(' ').map(int.parse).toList())
      .toList();

  print(readings.map(getNextReading).sum);
  print(readings.map(getPreviousReading).sum);
}

int getNextReading(List<int> reading) {
  final lastValues = <int>[reading.last];
  List<int> diff = reading.differences;
  while (!diff.isAllZeroes) {
    lastValues.add(diff.last);
    diff = diff.differences;
  }
  return lastValues.sum;
}

int getPreviousReading(List<int> reading) {
  final firstValues = <int>[reading.first];
  List<int> diff = reading;
  do {
    diff = diff.differences;
    firstValues.add(diff.first);
  } while (!diff.isAllZeroes);
  return firstValues.reversed.diff;
}
