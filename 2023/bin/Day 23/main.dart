import 'dart:collection';
import 'dart:io';
import 'dart:math';

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

  print(getLongestPathGraph(fillGraph(map), start, end));
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

Set<Position> getIntersections(List<List<String>> map) {
  Iterable<Position> intersectionsGenerator(List<List<String>> map) sync* {
    for (int i = 0; i < map.length; ++i) {
      for (int j = 0; j < map.length; ++j) {
        if (map[i][j] == '#') continue;
        final pathNeighbors = (i, j)
            .neighbors4
            .where((element) => !element.isOutOfBounds(map))
            .zippedWhere((row, col) => map[row][col] != '#')
            .length;
        if (pathNeighbors > 2) yield (i, j);
      }
    }
  }

  return intersectionsGenerator(map).toSet();
}

Map<Position, Map<Position, int>> fillGraph(List<List<String>> map) {
  final start = (
    0,
    map.first.indexed.firstWhere((element) => element.$2 == '.').$1,
  );
  final end = (
    map.length - 1,
    map.last.indexed.firstWhere((element) => element.$2 == '.').$1,
  );
  final intersections = getIntersections(map);
  intersections
    ..add(start)
    ..add(end);

  return intersections.toMapWithValue(
      (key) => getDistanceToConnectedIntersections(map, intersections, key));
}

Map<Position, int> getDistanceToConnectedIntersections(
  List<List<String>> map,
  Set<Position> intersections,
  Position origin,
) {
  final subgraph = <Position, int>{};
  final visited = <Position>{origin};
  final nextPositions = Queue<(Position, int)>.of(origin.neighbors4
      .where((element) => validMove(map, origin, element))
      .map((e) => (e, 1)));
  while (nextPositions.isNotEmpty) {
    final (currentPosition, steps) = nextPositions.removeFirst();
    visited.add(currentPosition);
    if (intersections.contains(currentPosition)) {
      subgraph[currentPosition] = steps;
      continue;
    }
    final neighbors = currentPosition.neighbors4
        .whereNot(visited.contains)
        .where((element) => validMove(map, currentPosition, element))
        .map((e) => (e, steps + 1));
    nextPositions.addAll(neighbors);
  }
  return subgraph;
}

int getLongestPathGraph(
  Map<Position, Map<Position, int>> graph,
  Position start,
  Position end,
) {
  final currentPaths =
      Queue<(Position, Set<Position>, int)>.of([(start, {}, 0)]);
  int maxPath = 0;
  while (currentPaths.isNotEmpty) {
    final (currentPosition, visited, distance) = currentPaths.removeFirst();
    if (currentPosition == end) {
      maxPath = max(maxPath, distance);
      continue;
    }
    currentPaths.addAll(graph[currentPosition]!
        .records
        .zippedWhere((next, _) => !visited.contains(next))
        .zippedMap((next, dist) =>
            (next, Set.of(visited)..add(currentPosition), distance + dist)));
  }
  return maxPath;
}
