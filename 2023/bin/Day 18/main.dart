import 'dart:io';

import '../common.dart';

void main() {
  final instructions = File('./bin/Day 18/input.txt')
      .readAsLinesSync()
      .map(processLine)
      .toList();

  print(getArea(getVertices(instructions.map((e) => (e.$1, e.$2)).toList())));
  print(getArea(
      getVertices(instructions.map((e) => processColor(e.$3)).toList())));
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
  int edgeLength = 0;
  for (int i = 0; i < vertices.length; ++i) {
    final j = (i + 1) % vertices.length;
    edgeLength += (vertices[j].row - vertices[i].row).abs() +
        (vertices[j].col - vertices[i].col).abs();
    area += vertices[i].row * vertices[j].col;
    area -= vertices[i].col * vertices[j].row;
  }
  return area.abs() ~/ 2 + edgeLength ~/ 2 + 1;
}
