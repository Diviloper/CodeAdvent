import 'dart:io';

import '../common/coords.dart';
import '../common/direction.dart';

void main() {
  first();
  second();
}


void first() {
  final instructions = File('src/Day 1/input.txt').readAsStringSync().split(', ');
  Coords current = Coords.origin();
  Direction direction = Direction.north;
  for (final instruction in instructions) {
    direction = instruction.startsWith('L') ? direction.turnLeft() : direction.turnRight();
    current = current.move(direction, int.parse(instruction.substring(1)));
  }
  print(current.distance);
}

void second() {
  final instructions = File('src/Day 1/input.txt').readAsStringSync().split(', ');
  Coords current = Coords.origin();
  final visited = <Coords>{};
  Direction direction = Direction.north;
  outer:
  for (final instruction in instructions) {
    direction = instruction.startsWith('L') ? direction.turnLeft() : direction.turnRight();
    final steps = int.parse(instruction.substring(1));
    for (int i=0; i<steps; ++i) {
      if (visited.contains(current)) break outer;
      visited.add(current);
      current = current.move(direction, 1);
    }
  }
  print(current.distance);}
