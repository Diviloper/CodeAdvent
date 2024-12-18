import 'dart:io';

import 'package:collection/collection.dart';

import '../directions.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split(',').map(int.parse).toList())
      .map((line) => Position.fromCoords(line.first, line.last))
      .toList();

  final x = 71;
  final y = 71;

  final first = aStar(
    input.take(1024).toSet(),
    Position((0, 0)),
    Position((x - 1, y - 1)),
    x,
    y,
  );
  print(first);

  final blockingByte = binarySearch(input, x, y);
  print("${blockingByte.i},${blockingByte.j}");
}

int? aStar(
    Set<Position> corrupted, Position start, Position end, int x, int y) {
  final seen = <Position, int>{};
  final queue = PriorityQueue<(Position, int)>((p0, p1) =>
      (p0.$2 + p0.$1.manhattanDistance(end))
          .compareTo(p1.$2 + p1.$1.manhattanDistance(end)));
  queue.add((start, 0));
  while (queue.isNotEmpty) {
    final (current, distance) = queue.removeFirst();
    seen[current] = distance;
    if (current == end) break;

    for (final direction in Direction.values) {
      final newPosition = current.advance(direction);
      if (corrupted.contains(newPosition) ||
          newPosition.outOfBounds(0, 0, x, y)) continue;
      if (seen.containsKey(newPosition) && seen[newPosition]! <= distance + 1) {
        continue;
      }
      queue.add((newPosition, distance + 1));
    }

  }
  return seen[end];
}

Position binarySearch(List<Position> input, int x, int y) {
  int lower = 0;
  int upper = input.length;

  while (lower < upper - 1) {
    final middle = lower + (upper - lower) ~/ 2;
    final corrupted = input.take(middle).toSet();
    final path =
        aStar(corrupted, Position((0, 0)), Position((x - 1, y - 1)), x, y) !=
            null;
    if (path) {
      lower = middle;
    } else {
      upper = middle;
    }
  }
  final blockingByte = input[lower];
  return blockingByte;
}

void printMap(int size, Set<Position> corrupted, Map<Position, int> seen) {
  for (int i = 0; i < size; ++i) {
    final s = Iterable.generate(
      size,
      (j) => corrupted.contains(Position((j, i)))
          ? "#"
          : seen[Position((j, i))]?.toString()[0] ?? ".",
    ).join();
    print(s);
  }
}
