import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final map = File('./bin/Day 17/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map(int.parse).toList())
      .toList();

  print(findFastestPath(map, 1, 3));
  print(findFastestPath(map, 4, 10));
}

int findFastestPath(
    List<List<int>> heatMap, int minStepsDirection, int maxStepsDirection) {
  final destination = (heatMap.length - 1, heatMap.last.length - 1);

  final costs = <Position, int>{};
  final visited = <(Position, Direction, int)>{};
  final nextSteps = PriorityQueue<(int, Position, Direction, int)>(
      (a, b) => a.$1.compareTo(b.$1));
  nextSteps.add((0, (0, 0), Direction.right, maxStepsDirection + 1));
  nextSteps.add((0, (0, 0), Direction.down, maxStepsDirection + 1));

  while (nextSteps.isNotEmpty) {
    final (cost, position, direction, directionSteps) = nextSteps.removeFirst();
    if (!costs.containsKey(position)) costs[position] = cost;
    if (position == destination) break;
    if (visited.contains((position, direction, directionSteps))) continue;
    visited.add((position, direction, directionSteps));
    if (directionSteps < maxStepsDirection) {
      final nextPos = position.move(direction);
      if (!nextPos.isOutOfBounds(heatMap)) {
        nextSteps.add((
          cost + heatMap[nextPos.row][nextPos.col],
          nextPos,
          direction,
          directionSteps + 1
        ));
      }
    }
    for (final dir in direction.perpendicular) {
      int addedCost = 0;
      Position nextPos = position;
      for (int i=0; i<minStepsDirection; ++i) {
        nextPos = nextPos.move(dir);
        if (nextPos.isOutOfBounds(heatMap)) break;
        addedCost += heatMap[nextPos.row][nextPos.col];
      }
      if (nextPos.isOutOfBounds(heatMap)) continue;
      nextSteps.add((
        cost + addedCost,
        nextPos,
        dir,
        minStepsDirection
      ));
    }
  }
  return costs[destination]!;
}
