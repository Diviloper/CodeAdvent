import 'dart:collection';
import 'dart:io';

import '../common.dart';

enum Pipe {
  vertical,
  horizontal,
  northEast,
  northWest,
  southEast,
  southWest,
  any,
  none;

  bool connectsHorizontally(Pipe? other) {
    const leftOptions = [
      Pipe.horizontal,
      Pipe.northEast,
      Pipe.southEast,
      Pipe.any
    ];
    const rightOptions = [
      Pipe.horizontal,
      Pipe.northWest,
      Pipe.southWest,
      Pipe.any
    ];
    return leftOptions.contains(this) && rightOptions.contains(other);
  }

  bool connectsVertically(Pipe? other) {
    const leftOptions = [
      Pipe.vertical,
      Pipe.southWest,
      Pipe.southEast,
      Pipe.any
    ];
    const rightOptions = [
      Pipe.vertical,
      Pipe.northWest,
      Pipe.northEast,
      Pipe.any
    ];
    return leftOptions.contains(this) && rightOptions.contains(other);
  }

  static Pipe fromString(String source) {
    switch (source) {
      case '|':
        return Pipe.vertical;
      case '-':
        return Pipe.horizontal;
      case 'L':
        return Pipe.northEast;
      case 'J':
        return Pipe.northWest;
      case '7':
        return Pipe.southWest;
      case 'F':
        return Pipe.southEast;
      case 'S':
        return Pipe.any;
    }
    return Pipe.none;
  }

  static bool connectHorizontally(String left, String right) {
    return Pipe.fromString(left).connectsHorizontally(Pipe.fromString(right));
  }

  static bool connectVertically(String up, String down) {
    return Pipe.fromString(up).connectsVertically(Pipe.fromString(down));
  }
}

void main() {
  final input = File('./bin/Day 10/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map(Pipe.fromString).toList())
      .toList();

  final position = getStartingPosition(input);
  final graph = processMap(input);

  final loop = getLoop(graph, position);
  print(((loop.length - 2) / 2).ceil());

  final map = cleanMap(input, loop);
  final inside = map.indexed
      .zippedExpand(
          (i, row) => row.indexed.zippedMap((j, pipe) => ((i, j), pipe)))
      .zippedWhere((pos, pipe) => pipe == Pipe.none)
      .zippedWhere((pos, pipe) => isInside(pos, loop, map));
  print(inside.length);
}

Position getStartingPosition(List<List<Pipe>> map) {
  for (final (i, row) in map.indexed) {
    for (final (j, cell) in row.indexed) {
      if (cell == Pipe.any) return (i, j);
    }
  }
  throw Exception("Starting position not found");
}

Map<Position, List<Position>> processMap(List<List<Pipe>> map) {
  final graph = <Position, List<Position>>{};
  for (int i = 0; i < map.length; ++i) {
    for (int j = 0; j < map[i].length; ++j) {
      final value = map[i][j];
      if (value == Pipe.none) continue;
      if (i < map.length - 1) {
        final neighborPipe = map[i + 1][j];
        if (value.connectsVertically(neighborPipe)) {
          graph.update((i, j), (value) => value..add((i + 1, j)),
              ifAbsent: () => [(i + 1, j)]);
          graph.update((i + 1, j), (value) => value..add((i, j)),
              ifAbsent: () => [(i, j)]);
        }
      }
      if (j < map[i].length - 1) {
        final neighborPipe = map[i][j + 1];
        if (value.connectsHorizontally(neighborPipe)) {
          graph.update((i, j), (value) => value..add((i, j + 1)),
              ifAbsent: () => [(i, j + 1)]);
          graph.update((i, j + 1), (value) => value..add((i, j)),
              ifAbsent: () => [(i, j)]);
        }
      }
    }
  }
  return graph;
}

List<Position> getLoop(Map<Position, List<Position>> graph, Position start) {
  final previous = <Position, Position>{};
  final pending = Queue<Position>.from([start]);
  Position otherEnd = start;
  Position current = start;
  while (pending.isNotEmpty) {
    current = pending.removeFirst();
    final neighbors = graph[current] ?? [];
    for (final neighbor in neighbors) {
      //if (neighbor == start) continue;
      if (previous.containsKey(neighbor)) {
        if (previous[current] != neighbor) {
          otherEnd = neighbor;
          break;
        }
      } else {
        previous[neighbor] = current;
        pending.add(neighbor);
      }
    }
  }
  final path = getPath(previous, current, start);
  final pathBack = getPath(previous, otherEnd, start);
  return path.reversed.toList() + pathBack;
}

List<Position> getPath(
  Map<Position, Position> guide,
  Position from,
  Position to,
) {
  final path = <Position>[from];
  Position current = from;
  while (current != to) {
    current = guide[current]!;
    path.add(current);
  }
  return path;
}

List<List<Pipe>> cleanMap(List<List<Pipe>> map, List<Position> path) {
  final newMap = map.map((e) => List.filled(e.length, Pipe.none)).toList();
  for (int i = 1; i < path.length - 1; ++i) {
    final (j, k) = path[i];
    newMap[j][k] = map[j][k];
  }

  newMap[path.first.$1][path.first.$2] =
      getConnectingPipe(path[1], path[path.length - 2]);

  return newMap;
}

Pipe getConnectingPipe(Position from, Position to) {
  switch (to - from) {
    case (0, -2):
    case (0, 2):
      return Pipe.horizontal;
    case (-2, 0):
    case (2, 0):
      return Pipe.vertical;
    case (-1, -1):
      return Pipe.northEast;
    case (1, 1):
      return Pipe.southWest;
    case (1, -1):
      return Pipe.southEast;
    case (-1, 1):
      return Pipe.northWest;
  }
  throw Exception("Not connecting");
}

bool isInside(Position position, List<Position> bounds, List<List<Pipe>> map) {
  if (bounds.contains(position)) return false;
  final i = position.$1;
  int crosses = 0;
  for (int j = position.$2; j >= 0; --j) {
    final cell = map[i][j];
    if (cell == Pipe.vertical) {
      ++crosses;
    } else if (cell == Pipe.none) {
      continue;
    } else {
      while (map[i][--j] == Pipe.horizontal) {}
      final nextCell = map[i][j];
      if ((cell, nextCell) case (Pipe.northWest, Pipe.southEast)) {
        ++crosses;
      } else if ((cell, nextCell) case (Pipe.southWest, Pipe.northEast)) {
        ++crosses;
      }
    }
  }
  return crosses.isOdd;
}
