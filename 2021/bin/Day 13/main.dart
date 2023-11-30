import 'dart:io';
import 'dart:math';

import '../common.dart';

void main() {
  final input = File('./input.txt').readAsLinesSync();
  final coords =
      input.sublist(0, input.indexWhere((element) => element.isEmpty));
  final instructions =
      input.sublist(input.indexWhere((element) => element.isEmpty) + 1);
  getFirstFoldPoints(coords, instructions);
  printFoldedManual(coords, instructions);
}

void printFoldedManual(List<String> coords, List<String> instructions) {
  Set<Tuple<int, int>> dots = {
    for (final coord in coords)
      Tuple<int, int>.fromList(coord.split(',').map(int.parse).toList())
  };
  for (final instruction in instructions) {
    final vertical = instruction.split(' ').last.split('=').first == 'x';
    final value = int.parse(instruction.split(' ').last.split('=').last);
    final foldedDots = {
      for (final dot in dots)
        if ((vertical ? dot.first : dot.second) > value)
          Tuple(vertical ? value - (dot.first - value) : dot.first,
              vertical ? dot.second : value - (dot.second - value))
        else
          dot
    };
    dots = foldedDots;
  }
  final minX = dots.map((e) => e.first).reduce(min);
  final maxX = dots.map((e) => e.first).reduce(max);
  final minY = dots.map((e) => e.second).reduce(min);
  final maxY = dots.map((e) => e.second).reduce(max);
  for (int i = minY; i <= maxY; ++i) {
    for (int j = minX; j <= maxX; ++j) {
      stdout.write(dots.contains(Tuple(j, i)) ? '█' : ' ');
    }
    stdout.writeln();
  }
}

void getFirstFoldPoints(List<String> coords, List<String> instructions) {
  Set<Tuple<int, int>> dots = {
    for (final coord in coords)
      Tuple<int, int>.fromList(coord.split(',').map(int.parse).toList())
  };
  final instruction = instructions.first;
  final vertical = instruction.split(' ').last.split('=').first == 'x';
  final value = int.parse(instruction.split(' ').last.split('=').last);
  final foldedDots = {
    for (final dot in dots)
      if ((vertical ? dot.first : dot.second) > value)
        Tuple(vertical ? value - (dot.first - value) : dot.first,
            vertical ? dot.second : value - (dot.second - value))
      else
        dot
  };
  print(foldedDots.length);
}
