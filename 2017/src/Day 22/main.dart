import 'dart:io';

import '../common.dart';

void main() {
  first();
  second();
}

String turnLeft(String currentDirection) {
  switch (currentDirection) {
    case 'U':
      return 'L';
    case 'L':
      return 'D';
    case 'D':
      return 'R';
    case 'R':
      return 'U';
  }
  throw 'Invalid direction';
}

String turnRight(String currentDirection) {
  switch (currentDirection) {
    case 'U':
      return 'R';
    case 'L':
      return 'U';
    case 'D':
      return 'L';
    case 'R':
      return 'D';
  }
  throw 'Invalid direction';
}

String reverse(String currentDirection) {
  switch (currentDirection) {
    case 'U':
      return 'D';
    case 'L':
      return 'R';
    case 'D':
      return 'U';
    case 'R':
      return 'L';
  }
  throw 'Invalid direction';
}

Coords move(Coords currentPosition, String direction) {
  switch (direction) {
    case 'U':
      return currentPosition.top();
    case 'D':
      return currentPosition.bottom();
    case 'R':
      return currentPosition.right();
    case 'L':
      return currentPosition.left();
  }
  throw 'Invalid direction';
}

enum State { clean, weakened, infected, flagged }

void first() {
  final initialGrid = File('src/Day 22/input.txt').readAsLinesSync();
  final center = initialGrid.length ~/ 2;
  final Set<Coords> infectedNodes = {};
  for (int i = 0; i < initialGrid.length; ++i) {
    for (int j = 0; j < initialGrid.length; ++j) {
      if (initialGrid[i][j] == '#') {
        infectedNodes.add(Coords(j - center, center - i));
      }
    }
  }
  String direction = 'U';
  Coords current = Coords.origin();
  int count = 0;
  for (int i = 0; i < 10000; ++i) {
    if (infectedNodes.contains(current)) {
      infectedNodes.remove(current);
      direction = turnRight(direction);
    } else {
      count++;
      infectedNodes.add(current);
      direction = turnLeft(direction);
    }
    current = move(current, direction);
  }
  print(count);
}

void second() {
  final initialGrid = File('src/Day 22/input.txt').readAsLinesSync();
  final center = initialGrid.length ~/ 2;
  final Map<Coords, State> nodes = {};
  for (int i = 0; i < initialGrid.length; ++i) {
    for (int j = 0; j < initialGrid.length; ++j) {
      if (initialGrid[i][j] == '#') {
        nodes[Coords(j - center, center - i)] = State.infected;
      }
    }
  }
  String direction = 'U';
  Coords current = Coords.origin();
  int count = 0;
  for (int i = 0; i < 10000000; ++i) {
    if (!nodes.containsKey(current)) nodes[current] = State.clean;
    switch (nodes[current]) {
      case State.clean:
        direction = turnLeft(direction);
        nodes[current] = State.weakened;
        break;
      case State.weakened:
        ++count;
        nodes[current] = State.infected;
        break;
      case State.infected:
        direction = turnRight(direction);
        nodes[current] = State.flagged;
        break;
      case State.flagged:
        direction = reverse(direction);
        nodes[current] = State.clean;
        break;
    }
    current = move(current, direction);
  }
  print(count);
}
