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

  var (map, minRow, minCol) =
      generateEdge(instructions.map((e) => (e.$1, e.$2)).toList());
  print(map.map((e) => e.count['#']!).toList().sum);
  fill(map, (1 + minRow, 1 + minCol));
  print(map.map((e) => e.count['#']!).toList().sum);

  print(getArea(getVertices(instructions.map((e) => (e.$1, e.$2)).toList())));
  print(getArea(getVertices(instructions.map((e) => processColor(e.$3)).toList())));
}

(List<List<String>>, int, int) generateEdge(
    List<(Direction, int)> instructions) {
  final edge = <Position>{};
  Position current = (0, 0);
  for (final (dir, steps) in instructions) {
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
  return (map, minRow.abs(), minCol.abs());
}

(Direction, int, String) processLine(String line) {
  final [dir, count, color] = line.split(' ');
  return (
    Direction.fromString(dir),
    int.parse(count),
    color.substring(1, color.length - 1)
  );
}

(Direction, int) processColor(String color) {
  return (
    switch (color[color.length - 1]) {
      '0' => Direction.right,
      '1' => Direction.down,
      '2' => Direction.left,
      '3' => Direction.up,
      _ => throw ArgumentError.value(color)
    },
    int.parse(color.substring(1, color.length - 1), radix: 16)
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

List<Position> getVertices(List<(Direction, int)> instructions) {
  final vertices = <Position>[];
  Position current = (0, 0);

  for (final (dir, steps) in instructions) {
    vertices.add(current);
    current = current.move(dir, steps);
  }

  return vertices;
}

int getArea(List<Position> vertices) {
  int area = 0;
  for (int i=0; i<vertices.length; ++i) {
    final j = (i + 1) % vertices.length;
    area += vertices[i].row * vertices[j].col;
    area -= vertices[i].col * vertices[j].row;
  }
  return area.abs();
}