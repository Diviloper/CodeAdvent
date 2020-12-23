import 'dart:io';

import '../common/coords.dart';
import '../common/direction.dart';

void main() {
  first();
  second();
}

void first() {
  final instructions = File('src/Day 2/input.txt').readAsLinesSync().map((e) => e.split(''));
  final directions = {
    'U': Direction.north,
    'D': Direction.south,
    'L': Direction.west,
    'R': Direction.east,
  };
  final buttons = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  String code = '';
  Coords position = Coords(1, 1);
  for (final instruction in instructions) {
    for (final direction in instruction) {
      final next = position.move(directions[direction], 1);
      if (next.x >= 0 && next.x < 3 && next.y >= 0 && next.y < 3) position = next;
    }
    code += '${buttons[2 - position.y][position.x]}';
  }
  print(code);
}

void second() {
  final instructions = File('src/Day 2/input.txt').readAsLinesSync().map((e) => e.split(''));
  final directions = {
    'U': Direction.north,
    'D': Direction.south,
    'L': Direction.west,
    'R': Direction.east,
  };
  final buttons = {
    Coords(0, 2): '1',
    Coords(-1, 1): '2',
    Coords(0, 1): '3',
    Coords(1, 1): '4',
    Coords(-2, 0): '5',
    Coords(-1, 0): '6',
    Coords(0, 0): '7',
    Coords(1, 0): '8',
    Coords(2, 0): '9',
    Coords(-1, -1): 'A',
    Coords(0, -1): 'B',
    Coords(1, -1): 'C',
    Coords(0, -2): 'D',
  };
  String code = '';
  Coords position = Coords(-2, 0);
  for (final instruction in instructions) {
    for (final direction in instruction) {
      final next = position.move(directions[direction], 1);
      if (buttons.containsKey(next)) position = next;
    }
    code += buttons[position];
  }
  print(code);
}
