import 'dart:collection';
import 'dart:io';

import '../common.dart';

void main() {
  final input = File('./bin/Day 21/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(''))
      .toList();
  final start = getStartingPosition(input);

  print(getPlotsReachableInSteps(input, 64, start));
}

Position getStartingPosition(List<List<String>> map) {
  for (final (i, row) in map.indexed) {
    for (final (j, cell) in row.indexed) {
      if (cell == 'S') return (i, j);
    }
  }
  throw "Starting Position not found";
}

int getPlotsReachableInSteps(List<List<String>> map, int steps, Position start,
    [bool endless = false]) {
  final even = <Position>{};
  final odd = <Position>{};
  final nextPositions = Queue<(Position, bool)>.from([(start, true)]);
  final futurePositions = Queue<(Position, bool)>();
  for (int i = 0; i <= steps; ++i) {
    while (nextPositions.isNotEmpty) {
      final (current, isEven) = nextPositions.removeFirst();
      final row = current.row % map.length;
      final col = current.col % map[row].length;
      if ((!endless && current.isOutOfBounds(map)) || map[row][col] == '#') {
        continue;
      }
      final set = isEven ? even : odd;
      if (set.contains(current)) continue;
      set.add(current);
      futurePositions.addAll(current.neighbors4
          .map((e) => (e, !isEven))
          .zippedWhere((pos, eve) => !(eve ? even : odd).contains(pos)));
    }
    nextPositions.addAll(futurePositions);
    futurePositions.clear();
  }
  return steps.isEven ? even.length : odd.length;
}
