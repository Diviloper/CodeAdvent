import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

enum Rock {
  round,
  square,
  none;

  static Rock fromString(String source) {
    switch (source) {
      case '#':
        return Rock.square;
      case 'O':
        return Rock.round;
      default:
        return Rock.none;
    }
  }

  @override
  String toString() {
    switch (this) {
      case Rock.square:
        return '#';
      case Rock.round:
        return 'O';
      case Rock.none:
        return '.';
    }
  }
}

void main() {
  final input = File('./bin/Day 14/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map(Rock.fromString).toList())
      .toList();

  print(getLoad(tilt(input)));

  final (start, cycle, rocks) = getCycle(input);
  final index = start + ((1000000000 - start) % (cycle));
  print(getLoad(rocks[index]));
}

List<List<Rock>> tilt(List<List<Rock>> start) {
  final newRocks = [
    for (final row in start) [for (final _ in row) Rock.none]
  ];
  for (int i = 0; i < start.length; ++i) {
    for (int j = 0; j < start[i].length; ++j) {
      if (start[i][j] == Rock.none) continue;
      if (start[i][j] == Rock.square) {
        newRocks[i][j] = Rock.square;
      } else {
        int k;
        for (k = i; k > 0; --k) {
          if (newRocks[k - 1][j] != Rock.none) break;
        }
        newRocks[k][j] = Rock.round;
      }
    }
  }
  return newRocks;
}

List<List<Rock>> spin(List<List<Rock>> rocks) {
  final north = tilt(rocks);
  final west = tilt(north.rotate());
  final south = tilt(west.rotate());
  final east = tilt(south.rotate());
  return east.rotate();
}

int getLoad(List<List<Rock>> rocks) => rocks
    .map((e) => e.where((element) => element == Rock.round).length)
    .toList()
    .reversed
    .indexed
    .zippedMap((i, v) => (i + 1) * v)
    .sum;

String rocksToString(List<List<Rock>> rocks) =>
    rocks.map((e) => e.join()).join('\n');

(int, int, List<List<List<Rock>>>) getCycle(List<List<Rock>> input) {
  var spun = input;
  final history = <String, int>{rocksToString(spun): 0};
  final rocks = <List<List<Rock>>>[spun];
  int i = 1;
  while (true) {
    spun = spin(spun);
    rocks.add(spun);
    final string = rocksToString(spun);
    if (history.containsKey(string)) {
      return (history[string]!, i - history[string]!, rocks);
    } else {
      history[string] = i;
    }
    i++;
  }
}
