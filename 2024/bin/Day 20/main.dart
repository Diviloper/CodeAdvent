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

  map.setAtPosition(start, ".");
  map.setAtPosition(end, ".");

  print(getSavingShortcuts(map, start, end, 2, 100));
  print(getSavingShortcuts(map, start, end, 20, 100));
}

Map<Position, int> dijkstra(
  List<List<String>> map,
  Position start,
) {
  final seen = <Position, int>{};
  final queue =
      PriorityQueue<(Position, int)>((p0, p1) => p0.$2.compareTo(p1.$2));
  queue.add((start, 0));
  while (queue.isNotEmpty) {
    final (current, distance) = queue.removeFirst();
    seen[current] = distance;

    for (final direction in Direction.values) {
      final newPos = current.advance(direction);
      if (map.outOfBoundsPos(newPos) || map.atPosition(newPos) == "#") {
        continue;
      }
      if (seen.containsKey(newPos) && seen[newPos]! <= distance + 1) {
        continue;
      }
      queue.add((newPos, distance + 1));
    }
  }

  return seen;
}

int getSavingShortcuts(List<List<String>> map, Position start, Position end,
    int jumpSize, int minSavings) {
  int count = 0;

  final distances = dijkstra(map, start);

  for (final MapEntry(key: startCheat, value: startDistance)
      in distances.entries) {
    for (final MapEntry(key: endCheat, value: endDistance)
        in distances.entries) {
      final shortcutDistance = startCheat.manhattanDistance(endCheat);
      if (shortcutDistance > jumpSize) continue;
      final savings = (endDistance - startDistance) - shortcutDistance;
      if (savings >= minSavings) ++count;
    }
  }
  return count;
}
