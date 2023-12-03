import 'dart:io';

import '../common.dart';

bool isNumeric(String s) => int.tryParse(s) != null;

void main() {
  final lines = File('./bin/Day 3/input.txt').readAsLinesSync();

  print(getPartNumbers(lines));
  print(getGearRatios(lines));
}

int getPartNumbers(List<String> lines) {
  final (numbers, symbols) = getCoords(lines);
  final symbolCoords = symbols.map((e) => e.$2).toList();
  return numbers
      .where((element) => isAdjacent(element.$2, element.$3, symbolCoords))
      .fold(0, (value, element) => value + element.$1);
}

(List<(int, Position, Position)>, List<(String, Position)>) getCoords(
    List<String> lines) {
  final numbers = <(int, Position, Position)>[];
  final symbols = <(String, Position)>[];
  for (final (i, line) in lines.indexed) {
    final chars = line.split('');
    for (int j = 0; j < chars.length; ++j) {
      if (chars[j] == '.') continue;
      if (!isNumeric(chars[j])) {
        symbols.add((chars[j], (i, j)));
        continue;
      }
      String n = '';
      while (j < chars.length && isNumeric(chars[j])) {
        n += chars[j++];
      }
      numbers.add((int.parse(n), (i, j - n.length), (i, --j)));
    }
  }
  return (numbers, symbols);
}

bool isAdjacent(Position start, Position end, List<Position> symbols) {
  assert(start.$1 == end.$1);
  final numRow = start.$1;
  for (final (sRow, sCol) in symbols) {
    if (sRow < numRow - 1) continue;
    if (sRow > numRow + 1) break;
    if ((sRow, sCol).isAdjacentColumnRange(numRow, start.$2, end.$2)) {
      return true;
    }
  }
  return false;
}

int getGearRatios(List<String> lines) {
  final (numbers, symbols) = getCoords(lines);
  final potentialGears =
      symbols.where((element) => element.$1 == '*').map((e) => e.$2);
  int sum = 0;
  for (final gear in potentialGears) {
    final adjacentNumbers = <int>[];
    for (final (number, start, end) in numbers) {
      if (start.$1 < gear.$1 - 1) continue;
      if (start.$1 > gear.$1 + 1) break;
      if (gear.isAdjacentColumnRange(start.$1, start.$2, end.$2)) {
        adjacentNumbers.add(number);
      }
    }
    if (adjacentNumbers.length == 2) {
      sum += adjacentNumbers.first * adjacentNumbers.last;
    }
  }
  return sum;
}
