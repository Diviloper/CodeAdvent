import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final (left, right) = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split("   ").map(int.parse).toList())
      .map((e) => (e.first, e.last))
      .unzip();

  first(left.copy(), right.copy());
  second(left.copy(), right.copy());
}

void first(List<int> left, List<int> right) {
  left.sort();
  right.sort();

  int totalDistance = IterableZip([left, right])
      .map((e) => (e[1] - e[0]).abs())
      .fold(0, (total, element) => total + element);

  print(totalDistance);
}

void second(List<int> left, List<int> right) {
  final counter = right.count;
  int totalCount =
      left.fold(0, (total, element) => total + element * counter[element]);

  print(totalCount);
}
