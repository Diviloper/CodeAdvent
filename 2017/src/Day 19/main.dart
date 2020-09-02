import 'dart:io';

import '../common.dart';

void main() {
  first();
  second();
}

void first() {
  final map = File('src/Day 19/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(''))
      .toList();
  Map<String, Coords Function(Coords)> move = {
    'B': (c) => c.top(),
    'T': (c) => c.bottom(),
    'R': (c) => c.right(),
    'L': (c) => c.left(),
  };
  String direction = 'B';
  String visited = '';
  Coords current = Coords(39, 0);
  outer:
  while (true) {
    while (map[current.y][current.x] != '+') {
      current = move[direction](current);
      if (RegExp(r'[A-Z]').hasMatch(map[current.y][current.x])) {
        visited += map[current.y][current.x];
      } else if (map[current.y][current.x] == ' ') break outer;
    }
    if (direction == 'T' || direction == 'B') {
      if (map[current.y][current.x - 1] == '-')
        direction = 'L';
      else if (map[current.y][current.x + 1] == '-')
        direction = 'R';
      else
        break;
    } else {
      if (map[current.y - 1][current.x] == '|')
        direction = 'T';
      else if (map[current.y + 1][current.x] == '|')
        direction = 'B';
      else
        break;
    }
    current = move[direction](current);
  }
  print(visited);
}

void second() {
  final map = File('src/Day 19/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(''))
      .toList();
  Map<String, Coords Function(Coords)> move = {
    'B': (c) => c.top(),
    'T': (c) => c.bottom(),
    'R': (c) => c.right(),
    'L': (c) => c.left(),
  };
  String direction = 'B';
  int steps = 0;
  Coords current = Coords(39, 0);
  outer:
  while (true) {
    while (map[current.y][current.x] != '+') {
      current = move[direction](current);
      ++steps;
      if (map[current.y][current.x] == ' ') break outer;
    }
    if (direction == 'T' || direction == 'B') {
      if (map[current.y][current.x - 1] == '-')
        direction = 'L';
      else if (map[current.y][current.x + 1] == '-')
        direction = 'R';
      else
        break;
    } else {
      if (map[current.y - 1][current.x] == '|')
        direction = 'T';
      else if (map[current.y + 1][current.x] == '|')
        direction = 'B';
      else
        break;
    }
    current = move[direction](current);
    ++steps;
  }
  print(steps);
}
