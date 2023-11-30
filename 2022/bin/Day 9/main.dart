import 'dart:io';

import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int x;
  final int y;

  Position(this.x, this.y);

  int distance(Position other) => xDistance(other) + yDistance(other);

  int xDistance(Position other) => (x - other.x).abs();

  int yDistance(Position other) => (y - other.y).abs();

  bool touches(Position other) => xDistance(other) < 2 && yDistance(other) < 2;

  Position move(String step) {
    switch (step.toUpperCase()) {
      case 'L':
        return Position(x - 1, y);
      case 'R':
        return Position(x + 1, y);
      case 'U':
        return Position(x, y + 1);
      case 'D':
        return Position(x, y - 1);
    }
    throw Exception();
  }

  Position moveCloser(Position other) {
    final xDif = other.x - x;
    final yDif = other.y - y;
    return Position(x + xDif.compareTo(0), y + yDif.compareTo(0));
  }

  @override
  List<Object> get props => [x, y];
}

void main() {
  List<String> steps = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split(' '))
      .expand((element) => List.filled(int.parse(element[1]), element[0]))
      .toList();

  visitedPositions(steps, 2);
  visitedPositions(steps, 10);
}

void visitedPositions(List<String> steps, int knots) {
  List<Position> rope = List.generate(knots, (index) => Position(0, 0));
  Set<Position> visited = {rope.last};

  for (final step in steps) {
    rope.first = rope.first.move(step);
    for (int i = 1; i < rope.length; i++) {
      if (!rope[i].touches(rope[i - 1])) {
        rope[i] = rope[i].moveCloser(rope[i - 1]);
      } else {
        break;
      }
    }
    visited.add(rope.last);
  }
  print(visited.length);
}
