import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';
import '../directions.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split('').map(int.parse).toList())
      .toList();

  final zeroPositions = input
      .indexedExpand((i, row) => row.indexed
          .zippedWhere((j, cell) => cell == 0)
          .zippedMap((j, cell) => Position.fromCoords(i, j)))
      .toList();

  final first = zeroPositions.map((pos) => countPeaks(input, pos)).sum;
  print(first);

  final second = zeroPositions.map((pos) => countTrails(input, pos).length).sum;
  print(second);
}

List<Position> countTrails(List<List<int>> map, Position trailhead) {
  List<Position> peaks = [];
  Queue<Position> currentPositions = Queue.from([trailhead]);
  while (currentPositions.isNotEmpty) {
    final current = currentPositions.removeFirst();
    if (map.atPosition(current) == 9) {
      peaks.add(current);
      continue;
    }
    for (final direction in Direction.values) {
      final step = current.advance(direction);
      if (!map.outOfBoundsPos(step) &&
          map.atPosition(current) + 1 == map.atPosition(step)) {
        currentPositions.addLast(step);
      }
    }
  }
  return peaks;
}

int countPeaks(List<List<int>> map, Position trailhead) =>
    countTrails(map, trailhead).toSet().length;
