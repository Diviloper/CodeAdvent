import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final map = File('./bin/Day 23/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(''))
      .toList();

  final start = (
    0,
    map.first.indexed.firstWhere((element) => element.$2 == '.').$1,
  );
  final end = (
    map.length - 1,
    map.last.indexed.firstWhere((element) => element.$2 == '.').$1,
  );
  print(getLongestPath(map, start, end, {}));
  for (int i = 0; i < map.length; ++i) {
    for (int j = 0; j < map[i].length; ++j) {
      map[i][j] = map[i][j] == '#' ? '#' : '.';
    }
  }
  print(getLongestPath(map, start, end, {}));
}

int getLongestPath(List<List<String>> map, Position start, Position end,
    Set<Position> visited) {
  if (start == end) return 0;
  int steps = 0;
  Position current = start;
  while (current != end) {
    final neighbors = current.neighbors4;
    final next = neighbors
        .where((element) => !visited.contains(element))
        .where((to) => validMove(map, current, to))
        .toList();
    if (next.isEmpty) {
      print('Dead end');
      return -999999;
    } else if (next.length == 1) {
      visited.add(current);
      current = next.single;
      steps++;
    } else {
      return steps +
          1 +
          next
              .map((e) =>
                  getLongestPath(map, e, end, Set.from(visited)..add(current)))
              .max;
    }
  }
  return steps;
}

bool validMove(List<List<String>> map, Position from, Position to) {
  if (to.isOutOfBounds(map)) return false;
  final cell = map[to.row][to.col];
  if (cell == '#') return false;
  if (cell == '.') return true;

  return switch (cell) {
    '>' => to - from == (0, 1),
    '<' => to - from == (0, -1),
    'v' => to - from == (1, 0),
    '^' => to - from == (-1, 0),
    _ => throw ArgumentError.value(cell),
  };
}
