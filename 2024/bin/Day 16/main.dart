import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

import '../directions.dart';

void main() {
  final map = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split(''))
      .toList();

  final start = map.positionsWhere((p) => map.atPosition(p) == 'S').single;
  final end = map.positionsWhere((p) => map.atPosition(p) == 'E').single;

  final (first, costs) = bfs(map, start, Direction.right, end);
  print(first);

  final second = cellsInPath(map, start, end, first, costs);
  print(second);
}

(int, Map<(Position, Direction), int>) bfs(
  List<List<String>> map,
  Position start,
  Direction startDir,
  Position end,
) {
  final cost = <(Position, Direction), int>{};
  final queue = Queue<(Position, Direction, int)>();
  queue.add((start, startDir, 0));
  while (queue.isNotEmpty) {
    final (currentPosition, currentDirection, currentCost) =
        queue.removeFirst();
    if (cost.containsKey((currentPosition, currentDirection)) &&
        cost[(currentPosition, currentDirection)]! <= currentCost) continue;
    cost[(currentPosition, currentDirection)] = currentCost;
    final possibleDirs = [
      currentDirection,
      currentDirection.turnRight(),
      currentDirection.turnLeft()
    ];
    for (final direction in possibleDirs) {
      final newPos = currentPosition.advance(direction);
      if (map.outOfBoundsPos(newPos) || map.atPosition(newPos) == "#") continue;
      queue.add((
        newPos,
        direction,
        currentCost + (direction == currentDirection ? 1 : 1001)
      ));
    }
  }
  return (Direction.values.map((d) => cost[(end, d)]).nonNulls.min, cost);
}

int cellsInPath(
  List<List<String>> map,
  Position start,
  Position end,
  int totalCost,
  Map<(Position, Direction), int> costs,
) {
  int count = 0;

  for (final position in map.positions()) {
    if (map.atPosition(position) == "#") continue;

    for (final direction in Direction.values) {
      if (!costs.containsKey((position, direction))) continue;
      final cost = costs[(position, direction)]!;
      if (cost > totalCost) continue;
      try {
        final remainingCost = bfs(map, position, direction, end).$1;
        if (cost + remainingCost == totalCost) {
          ++count;
          break;
        }
      } on Error {
        continue;
      }
    }
  }
  return count;
}
