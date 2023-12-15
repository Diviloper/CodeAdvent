import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final input = File('./bin/Day 15/input.txt').readAsStringSync().split(',');

  print(input.map(hash).sum);

  final boxes = <int, Map<String, int>>{};
  for (final e in input) {
    processStep(e, boxes);
  }
  print(boxes.entries
      .map((e) => (e.key, e.value))
      .zippedMap((box, lenses) =>
          (box + 1) *
          lenses.values.indexed
              .zippedMap((first, second) => (first + 1) * second)
              .sum)
      .sum);
}

int hash(String source) =>
    source.codeUnits.fold(0, (h, char) => (h + char) * 17 % 256);

void processStep(String operation, Map<int, Map<String, int>> boxes) {
  if (operation.endsWith('-')) {
    removeLens(operation.replaceFirst('-', ''), boxes);
  } else {
    final [label, focalLength] = operation.split('=');
    addLens(label, int.parse(focalLength), boxes);
  }
}

void removeLens(String label, Map<int, Map<String, int>> boxes) {
  final i = hash(label);
  boxes[i]?.remove(label);
}

void addLens(String label, int focalLength, Map<int, Map<String, int>> boxes) {
  final i = hash(label);
  if (boxes.containsKey(i)) {
    boxes[i]?[label] = focalLength;
  } else {
    boxes[i] = {label: focalLength};
  }
}
