import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';
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


  const jumpSize = 20;
  const minSavings = 50;

  final memorySave = "./memory${map.length}.json";
  final generate = false;
  final Map<(Position, Position), int> shortestPaths;
  if (generate) {
    shortestPaths = fullMemory(map);
    print("Fully Mapped. Saving...");
    saveMemory(shortestPaths, memorySave);
    print("Saved");
  } else {
    print("Loading memory...");
    shortestPaths = loadMemory(memorySave);
    print("Memory loaded");
  }

  List<int> savings =
      computeSavings(map, jumpSize, start, end, shortestPaths, minSavings);
  print(savings.length);
}

List<int> computeSavings(
    List<List<String>> map,
    int jumpSize,
    Position start,
    Position end,
    Map<(Position, Position), int> shortestPaths,
    int minSavings) {
  final shortestLength = shortestPaths[(start, end)]!;
  final saves = <int>[];
  final seenCheats = <(Position, Position)>{};
  for (int i = 0; i < map.length; ++i) {
    for (int j = 0; j < map[i].length; ++j) {
      final pos = Position.fromCoords(i, j);

      if (map.atPosition(pos) == "#") continue;

      final cheatJumps = jumps(map, pos, jumpSize);

      for (final (startCheat, endCheat) in cheatJumps) {
        if (seenCheats.contains((startCheat, endCheat))) continue;

        final minNewDistance = start.manhattanDistance(startCheat) +
            startCheat.manhattanDistance(endCheat) +
            endCheat.manhattanDistance(end);
        if (minNewDistance > shortestLength) continue;

        final firstLength = shortestPaths[(start, startCheat)];
        final lastLength = shortestPaths[(endCheat, end)];
        if (firstLength == null || lastLength == null) continue;

        final totalLength =
            firstLength + startCheat.manhattanDistance(endCheat) + lastLength;

        final savings = shortestLength - totalLength;
        if (savings >= minSavings) {
          saves.add(savings);
        }
        seenCheats.add((startCheat, endCheat));
      }
    }
    print("Row $i of ${map.length}");
  }
  print(saves.sorted((a, b) => a.compareTo(b)).count);
  return saves;
}

void saveMemory(
    Map<(Position, Position), int> shortestPaths, String memorySave) {
  String toJson((Position, Position) tuple) {
    return "${tuple.$1.i},${tuple.$1.j},${tuple.$2.i},${tuple.$2.j}";
  }

  File(memorySave).writeAsStringSync(
    JsonEncoder.withIndent("  ")
        .convert(shortestPaths.map((k, v) => MapEntry(toJson(k), v))),
  );
}

Map<(Position, Position), int> loadMemory(String memorySave) {
  final content = File(memorySave).readAsStringSync();
  final json = jsonDecode(content) as Map<String, dynamic>;

  (Position, Position) parsePositions(String s) {
    final [si, sj, ei, ej] = s.split(',').map(int.parse).toList();
    return (Position((si, sj)), Position((ei, ej)));
  }

  return json.map((key, value) => MapEntry(parsePositions(key), value as int));
}

Iterable<(Position, Position)> jumps(
    List<List<String>> map, Position start, int length) sync* {
  final walls = Direction.values
      .map(start.advance)
      .where((p) => map.atPosition(p) == "#");
  for (final wallPos in walls) {
    final reachableCells = jumpFrom(wallPos, length - 1)
        .where((p) => !map.outOfBoundsPos(p))
        .where((p) => map.atPosition(p) == ".");
    for (final end in reachableCells) {
      yield (start, end);
    }
  }
}

Iterable<Position> jumpFrom(Position start, int jump) sync* {
  for (int i = 1; i <= jump; ++i) {
    yield Position.fromCoords(start.i - i, start.j);
    yield Position.fromCoords(start.i + i, start.j);
    yield Position.fromCoords(start.i, start.j - i);
    yield Position.fromCoords(start.i, start.j + i);
    for (int j = 1; j <= jump - i; ++j) {
      yield Position.fromCoords(start.i - i, start.j - j);
      yield Position.fromCoords(start.i - i, start.j + j);
      yield Position.fromCoords(start.i + i, start.j - j);
      yield Position.fromCoords(start.i + i, start.j + j);
    }
  }
}

Map<(Position, Position), int> fullMemory(List<List<String>> map) {
  final memory = <(Position, Position), int>{};
  int i = 1;
  for (final position in map.positions()) {
    if (++i % 100 == 0) {
      print("Mapping $i of ${map.length * map.length}");
    }
    if (map.atPosition(position) == "#") continue;
    dijkstra(map, position, memory);
  }
  return memory;
}

void dijkstra(
  List<List<String>> map,
  Position start,
  Map<(Position, Position), int> memory,
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

  for (final end in seen.keys) {
    memory[(start, end)] = seen[end]!;
  }
}
