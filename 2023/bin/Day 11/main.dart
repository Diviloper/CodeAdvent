import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final lines = File('./bin/Day 11/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(''))
      .toList();

  final (emptyRows, emptyColumns) = getEmpty(lines);

  final galaxies = getGalaxyPositions(lines)
      .map((galaxy) => expand(galaxy, emptyRows, emptyColumns, 2))
      .toList();
  print(galaxies.triangularProduct().zippedMap(manhattanDistance).sum);

  final oldGalaxies = getGalaxyPositions(lines)
      .map((galaxy) => expand(galaxy, emptyRows, emptyColumns, 1000000))
      .toList();
  print(oldGalaxies.triangularProduct().zippedMap(manhattanDistance).sum);
}

(List<int>, List<int>) getEmpty(List<List<String>> lines) {
  final rows = lines.indexed
      .zippedWhere((i, row) => row.every((pixel) => pixel == '.'))
      .firsts
      .toList();
  final columns = List.generate(lines.first.length, (index) => index)
      .where((i) => lines.every((row) => row[i] == '.'))
      .toList();
  return (rows, columns);
}

List<Position> getGalaxyPositions(List<List<String>> lines) {
  return lines.indexed
      .zippedExpand((i, row) => row.indexed
          .zippedWhere((j, cell) => cell == '#')
          .firsts
          .map((j) => (i, j)))
      .toList();
}

Position expand(Position e, List<int> expandedRows, List<int> expandedCols,
        int factor) =>
    (
      e.$1 + (expandedRows.where((row) => row < e.$1).length * (factor - 1)),
      e.$2 + (expandedCols.where((col) => col < e.$2).length * (factor - 1)),
    );
