import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';
import '../directions.dart';

void main() {
  final input = File('./input.txt')
      .readAsStringSync()
      .split('${Platform.lineTerminator}${Platform.lineTerminator}');
  final map = input.first
      .split(Platform.lineTerminator)
      .map((row) => row.split(''))
      .toList();
  final moves = input.last
      .split(Platform.lineTerminator)
      .join()
      .split('')
      .map(Direction.fromString)
      .toList();

  int first = smallWarehouse(map, moves);
  print(first);

  final largeMap = map
      .map((row) => row
          .expand((cell) => switch (cell) {
                "@" => ["@", "."],
                "#" => ["#", "#"],
                "O" => ["[", "]"],
                "." => [".", "."],
                String() => throw UnimplementedError(),
              })
          .toList())
      .toList();

  int second = largeWarehouse(largeMap, moves);
  print(second);
}

int smallWarehouse(List<List<String>> map, List<Direction> moves) {
  final robot = map.positionsWhere((pos) => map.atPosition(pos) == "@").single;
  final walls = map.positionsWhere((pos) => map.atPosition(pos) == "#").toSet();
  final boxes = map.positionsWhere((pos) => map.atPosition(pos) == "O").toSet();

  Position currentPosition = robot;
  for (final move in moves) {
    final nextPos = currentPosition.advance(move);
    if (walls.contains(nextPos)) continue;
    if (!boxes.contains(nextPos)) {
      currentPosition = nextPos;
      continue;
    }

    final movingBoxes = {nextPos};
    Position nextBox = nextPos.advance(move);
    while (boxes.contains(nextBox)) {
      movingBoxes.add(nextBox);
      nextBox = nextBox.advance(move);
    }
    if (walls.contains(nextBox)) continue;

    currentPosition = nextPos;
    boxes.removeAll(movingBoxes);
    boxes.addAll(movingBoxes.map((p) => p.advance(move)));
  }

  final first = boxes.map((box) => box.i * 100 + box.j).sum;
  return first;
}

int largeWarehouse(List<List<String>> map, List<Direction> moves) {
  final robot = map.positionsWhere((pos) => map.atPosition(pos) == "@").single;
  final walls = map.positionsWhere((pos) => map.atPosition(pos) == "#").toSet();
  final boxes = map
      .positionsWhere(
        (pos) => map.atPosition(pos) == "[" || map.atPosition(pos) == "]",
      )
      .map((pos) => (pos, map.atPosition(pos) == "]"))
      .toMap();

  Position currentPosition = robot;
  for (final move in moves) {
    final nextPos = currentPosition.advance(move);
    if (walls.contains(nextPos)) continue;
    if (!boxes.containsKey(nextPos)) {
      currentPosition = nextPos;
      continue;
    }

    final movingBoxes = <(Position, bool)>{};
    final nextBoxes = Queue<Position>.from([nextPos]);
    bool wall = false;
    while (nextBoxes.isNotEmpty) {
      final nextBox = nextBoxes.removeFirst();

      if (movingBoxes.contains((nextBox, true)) ||
          movingBoxes.contains((nextBox, false))) continue;
      if (walls.contains(nextBox)) {
        wall = true;
        break;
      }
      if (!boxes.containsKey(nextBox)) continue;

      final boxHalf = boxes[nextBox]!
          ? nextBox.advance(Direction.left)
          : nextBox.advance(Direction.right);

      movingBoxes.add((nextBox, boxes[nextBox]!));
      movingBoxes.add((boxHalf, boxes[boxHalf]!));

      nextBoxes.add(nextBox.advance(move));
      nextBoxes.add(boxHalf.advance(move));
    }
    if (wall) continue;

    currentPosition = nextPos;
    boxes.removeWhere((p, v) => movingBoxes.contains((p, v)));

    boxes.addAll(movingBoxes.zippedMap((k, v) => (k.advance(move), v)).toMap());
  }

  return boxes
      .toRecords()
      .zippedWhere((pos, side) => !side)
      .zippedMap((pos, side) => pos.i * 100 + pos.j)
      .sum;
}
