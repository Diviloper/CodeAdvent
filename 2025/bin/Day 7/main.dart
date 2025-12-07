import 'dart:io';
import 'package:collection/collection.dart';

import '../directions.dart';
import '../common.dart';

void main() {
  final input = File(
    './input.txt',
  ).readAsLinesSync().map((row) => row.split("")).toList();

  first(input);
  second(input);
}

void first(List<List<String>> input) {
  Set<Position> positions = {
    input.positionsValueWhere((p, v) => v == "S").single,
  };
  int splits = 0;
  while (positions.isNotEmpty) {
    final newPositions = <Position>{};
    for (final pos in positions) {
      final newPos = pos.advance(Direction.down);
      if (input.outOfBoundsPos(newPos)) continue;
      if (input.atPosition(newPos) == ".") newPositions.add(newPos);
      if (input.atPosition(newPos) == "^") {
        ++splits;
        newPositions.add(newPos.advance(Direction.left));
        newPositions.add(newPos.advance(Direction.right));
      }
    }
    positions = newPositions;
  }
  print(splits);
}

void second(List<List<String>> input) {
  Counter<Position> timelines = Counter.fromIterable([
    input.positionsValueWhere((p, v) => v == "S").single,
  ]);
  while (true) {
    final newTimelines = Counter<Position>();
    for (final (pos, numTimelines) in timelines.records()) {
      final newPos = pos.advance(Direction.down);
      if (input.outOfBoundsPos(newPos)) continue;
      if (input.atPosition(newPos) == ".") {
        newTimelines.increase(newPos, numTimelines);
      }
      if (input.atPosition(newPos) == "^") {
        newTimelines.increase(newPos.advance(Direction.left), numTimelines);
        newTimelines.increase(newPos.advance(Direction.right), numTimelines);
      }
    }
    if (newTimelines.isEmpty) break;
    timelines = newTimelines;
  }
  print(timelines.values.sum);
}
