import 'dart:io';

import '../shared.dart';

extension Pos<T> on List<List<T>> {
  T at(Position position) => this[position.x][position.y];

  bool valid(Position position) =>
      position.x >= 0 &&
          position.x < length &&
          position.y >= 0 &&
          position.y < this[position.x].length;
}

void main() {
  List<List<int>> map = File('input.txt')
      .readAsLinesSync()
      .map((e) =>
      e.split('').map((e) => e.codeUnitAt(0) - 'a'.codeUnitAt(0)).toList())
      .toList();
  final start = Position(20, 0);
  final end = Position(20, 135);

  bfs(map, start, end);
  mbfs(map, end);
}

void mbfs(List<List<int>> map, Position end) {
  int min = map.length * map.first.length;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; ++j) {
      if (map[i][j] != 0) continue;
      final distance = bfs(map, Position(i, j), end);
      if (distance != null && distance < min) {
        min = distance;
      }
    }
  }
  print(min);
}

int? bfs(List<List<int>> map, Position start, Position end) {
  final stack = <Position>[start];
  final steps = {start: 0};
  Position current;
  do {
    current = stack.removeAt(0);
    for (final neighbor in current.neighbours()) {
      if (map.valid(neighbor) &&
          !steps.containsKey(neighbor) &&
          map.at(neighbor) <= map.at(current) + 1) {
        stack.add(neighbor);
        steps[neighbor] = steps[current]! + 1;
      }
    }
  } while (current != end && stack.isNotEmpty);
  print(steps[end]);
  return steps[end];
}
