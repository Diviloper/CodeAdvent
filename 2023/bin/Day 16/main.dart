import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final map = File('./bin/Day 16/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(''))
      .toList();

  print(getTotalEnergy(energizeMap(map)));
  print(getOptimalEnergy(map));
}

List<List<int>> energizeMap(
  List<List<String>> map, [
  (Position, Direction) start = ((0, 0), Direction.right),
]) {
  final energyMap = [
    for (final row in map) [for (final _ in row) 0]
  ];

  final nextSteps =
      Queue<(Position, Direction)>.from([start]);
  final visited = <(Position, Direction)>{};

  while (nextSteps.isNotEmpty) {
    final (position, direction) = nextSteps.removeFirst();
    if (position.isOutOfBounds(map)) continue;
    if (visited.contains((position, direction))) continue;
    visited.add((position, direction));
    energyMap[position.row][position.col] = 1;

    switch (map[position.row][position.col]) {
      case '.':
        nextSteps.add((position.move(direction), direction));
        break;
      case '-':
        if (direction.isVertical) {
          nextSteps.add((position.move(Direction.left), Direction.left));
          nextSteps.add((position.move(Direction.right), Direction.right));
        } else {
          nextSteps.add((position.move(direction), direction));
        }
        break;
      case '|':
        if (direction.isHorizontal) {
          nextSteps.add((position.move(Direction.up), Direction.up));
          nextSteps.add((position.move(Direction.down), Direction.down));
        } else {
          nextSteps.add((position.move(direction), direction));
        }
        break;
      case '/':
        final newDir = switch (direction) {
          Direction.right => Direction.up,
          Direction.up => Direction.right,
          Direction.left => Direction.down,
          Direction.down => Direction.left,
        };
        nextSteps.add((position.move(newDir), newDir));
        break;
      case r'\':
        final newDir = switch (direction) {
          Direction.right => Direction.down,
          Direction.up => Direction.left,
          Direction.left => Direction.up,
          Direction.down => Direction.right,
        };
        nextSteps.add((position.move(newDir), newDir));
        break;
    }
  }

  return energyMap;
}

int getTotalEnergy(List<List<int>> energyMap) =>
    energyMap.map((row) => row.sum).sum;

int getOptimalEnergy(List<List<String>> map) {
  int maxEnergy = 0;
  for (int col = 0; col < map.length; ++col) {
    final down = energizeMap(map, ((0, col), Direction.down));
    maxEnergy = max(maxEnergy, getTotalEnergy(down));
    final up = energizeMap(map, ((map.length - 1, col), Direction.up));
    maxEnergy = max(maxEnergy, getTotalEnergy(up));
  }

  for (int row = 0; row < map.first.length; ++row) {
    final right = energizeMap(map, ((row, 0), Direction.right));
    maxEnergy = max(maxEnergy, getTotalEnergy(right));
  }

  for (int row = 0; row < map.last.length; ++row) {
    final left =
        energizeMap(map, ((row, map.last.length - 1), Direction.right));
    maxEnergy = max(maxEnergy, getTotalEnergy(left));
  }
  return maxEnergy;
}
