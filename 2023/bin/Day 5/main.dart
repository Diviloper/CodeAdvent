import 'dart:io';

import 'package:collection/collection.dart';

Iterable<int> naturals() sync* {
  int i = 0;
  while (true) {
    yield i++;
  }
}

class CategoryMap {
  final List<(int, int, int)> ranges = [];
  final String source;
  final String destination;

  CategoryMap(this.source, this.destination);

  void addRange(int sourceStart, int destinationStart, int length) {
    ranges.add((sourceStart, destinationStart, length));
  }

  int get(int source) {
    for (final ((sourceStart, destinationStart, length)) in ranges) {
      if (source >= sourceStart && source < sourceStart + length) {
        return destinationStart + (source - sourceStart);
      }
    }
    return source;
  }

  int getReversed(int destination) {
    for (final ((sourceStart, destinationStart, length)) in ranges) {
      if (destination >= destinationStart &&
          destination < destinationStart + length) {
        return sourceStart + (destination - destinationStart);
      }
    }
    return destination;
  }
}

void main() {
  final input = File('./bin/Day 5/input.txt').readAsStringSync().split('\n\n');
  final seeds = input.first.split(': ').last.split(' ').map(int.parse).toList();
  final maps = input.skip(1).map(processMap).toList();
  final path = getPathTo('seed', 'location', maps);

  print(seeds.map((e) => applyPath(e, path)).min);

  final seedRanges = seeds.slices(2).toList();

  final firstSeed = naturals()
      .map((e) => applyPathReversed(e, path))
      .firstWhere((seed) => seedRanges.any(
          (range) => seed >= range.first && seed < range.first + range.last));

  print(applyPath(firstSeed, path));
}

CategoryMap processMap(String input) {
  final lines = input.split('\n');
  final [source, _, destination] = lines.first.split(' ').first.split('-');
  final map = CategoryMap(source, destination);
  for (final line in lines.skip(1)) {
    final [dest, sour, len] = line.split(' ').map(int.parse).toList();
    map.addRange(sour, dest, len);
  }
  return map;
}

List<CategoryMap> getPathTo(
    String source, String destination, List<CategoryMap> maps) {
  String current = source;
  final path = <CategoryMap>[];
  while (current != destination) {
    path.add(maps.firstWhere((element) => element.source == current));
    current = path.last.destination;
  }
  return path;
}

int applyPath(int source, List<CategoryMap> path) {
  int current = source;
  for (final map in path) {
    current = map.get(current);
  }
  return current;
}

int applyPathReversed(int destination, List<CategoryMap> path) {
  int current = destination;
  for (final map in path.reversed) {
    current = map.getReversed(current);
  }
  return current;
}
