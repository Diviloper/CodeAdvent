import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

import '../directions.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split(''))
      .toList();

  final regions = findRegions(input);

  final first = regions.map((region) => area(region) * perimeter(region)).sum;
  print(first);

  final second = regions.map((region) => area(region) * numSides(region)).sum;
  print(second);
}
List<List<Position>> findRegions(List<List<String>> map) {
  final seen = <Position>{};
  final regions = <List<Position>>[];
  for (int i = 0; i < map.length; ++i) {
    for (int j = 0; j < map.length; ++j) {
      final pos = Position.fromCoords(i, j);
      if (seen.contains(pos)) continue;
      final region = expandRegion(map, pos);
      regions.add(region);
      seen.addAll(region);
    }
  }
  return regions;
}

List<Position> expandRegion(List<List<String>> map, Position initialPos) {
  final plantType = map.atPosition(initialPos);
  final seen = <Position>{};
  final stack = Queue<Position>.from([initialPos]);
  final region = <Position>[];
  while (stack.isNotEmpty) {
    final current = stack.removeFirst();
    if (seen.contains(current)) continue;
    if (map.atPosition(current) == plantType) {
      region.add(current);
      for (final direction in Direction.values) {
        final next = current.advance(direction);
        if (!map.outOfBoundsPos(next) && !seen.contains(next)) {
          stack.add(next);
        }
      }
    }
    seen.add(current);
  }
  return region;
}

int area(List<Position> region) => region.length;

int perimeter(List<Position> region) {
  int count = 0;
  for (final position in region) {
    for (final direction in Direction.values) {
      if (!region.contains(position.advance(direction))) ++count;
    }
  }
  return count;
}

int numSides(List<Position> region) {
  int count = 0;
  for (final position in region) {
    for (final direction in Direction.values) {
      final front = position.advance(direction);
      if (!region.contains(front) &&
          (!region.contains(position.advance(direction.turnRight())) ||
              region.contains(front.advance(direction.turnRight())))) {
        ++count;
      }
    }
  }
  return count;
}
