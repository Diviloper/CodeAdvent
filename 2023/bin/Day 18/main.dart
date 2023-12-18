import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final instructions = File('./bin/Day 18/input.txt')
      .readAsLinesSync()
      .map(processLine)
      .toList();

  final edge = <Position>{};
  Position current = (0, 0);
  for (final (dir, steps, color) in instructions) {
    for (int i = 0; i < steps; ++i) {
      edge.add(current);
      current = current.move(dir);
    }
  }
  final minRow = edge.firsts.reduce(min);
  final maxRow = edge.firsts.reduce(max);
  final rows = maxRow - minRow + 1;
  final minCol = edge.seconds.reduce(min);
  final maxCol = edge.seconds.reduce(max);
  final cols = maxCol - minCol + 1;
  final map = List<List<String>>.generate(
    rows,
    (row) => List<String>.generate(
        cols, (col) => edge.contains((minRow + row, minCol + col)) ? '#' : '.'),
  );
  // print(map.map((e) => e.join()).join('\n'));
  fill(map, (1 + minRow.abs(), 1 + minCol.abs()));
  print(map.map((e) => e.count['#']!).toList().sum);
}

(Direction, int, String) processLine(String line) {
  final [dir, count, color] = line.split(' ');
  return (
    Direction.fromString(dir),
    int.parse(count),
    color.substring(1, color.length - 1)
  );
}


void fill(List<List<String>> map, Position start) {
  final nextPositions = Queue<Position>.from([start]);
  while (nextPositions.isNotEmpty) {
    final current = nextPositions.removeFirst();
    if (current.isOutOfBounds(map)) continue;
    if (map[current.row][current.col] == '#') continue;
    map[current.row][current.col] = '#';
    nextPositions.addAll(current.neighbors4);
  }
}

