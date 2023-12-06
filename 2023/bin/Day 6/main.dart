import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final input = File('./bin/Day 6/input.txt').readAsLinesSync();

  final times = getRaces(input.first);
  final distances = getRaces(input.last);
  print(IterableZip([times, distances])
      .map((e) => getWaysToWin(e.first, e.last))
      .prod);

  final time = getSingleRace(input.first);
  final distance = getSingleRace(input.last);
  print(getWaysToWin(time, distance));
}

List<int> getRaces(String line) => line
    .split(':')
    .last
    .trim()
    .replaceAll(RegExp(r' +'), ' ')
    .split(' ')
    .map(int.parse)
    .toList();

int getSingleRace(String line) =>
    int.parse(line.split(':').last.replaceAll(RegExp(r' +'), ''));

int getWaysToWin(int time, int distance) {
  int halfTime = (time / 2).floor();
  int pressingTime;
  for (pressingTime = halfTime;
      pressingTime * (time - pressingTime) > distance;
      pressingTime--) {}
  final count = halfTime - pressingTime;
  return time.isEven ? count * 2 - 1 : count * 2;
}
