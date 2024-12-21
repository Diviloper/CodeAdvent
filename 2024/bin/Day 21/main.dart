import 'dart:io';

import 'package:collection/collection.dart';

import '../directions.dart';

final numericPositions = {
  Position.fromCoords(2, 0),
  Position.fromCoords(2, 1),
  Position.fromCoords(2, 2),
  Position.fromCoords(1, 0),
  Position.fromCoords(1, 1),
  Position.fromCoords(1, 2),
  Position.fromCoords(0, 0),
  Position.fromCoords(0, 1),
  Position.fromCoords(0, 2),
  Position.fromCoords(3, 1),
  Position.fromCoords(3, 2),
};

final directionalPositions = {
  Position.fromCoords(0, 2),
  Position.fromCoords(0, 1),
  Position.fromCoords(1, 0),
  Position.fromCoords(1, 1),
  Position.fromCoords(1, 2),
};

Position getNumericDigitPosition(String digit) => switch (digit) {
      "1" => Position.fromCoords(2, 0),
      "2" => Position.fromCoords(2, 1),
      "3" => Position.fromCoords(2, 2),
      "4" => Position.fromCoords(1, 0),
      "5" => Position.fromCoords(1, 1),
      "6" => Position.fromCoords(1, 2),
      "7" => Position.fromCoords(0, 0),
      "8" => Position.fromCoords(0, 1),
      "9" => Position.fromCoords(0, 2),
      "0" => Position.fromCoords(3, 1),
      "A" => Position.fromCoords(3, 2),
      _ => throw Exception(),
    };

Position getDirectionalDigitPosition(String digit) => switch (digit) {
      "A" => Position.fromCoords(0, 2),
      "^" => Position.fromCoords(0, 1),
      "<" => Position.fromCoords(1, 0),
      "v" => Position.fromCoords(1, 1),
      ">" => Position.fromCoords(1, 2),
      _ => throw Exception(),
    };

void main() {
  final codes = File('./input.txt').readAsLinesSync();

  final first = codes
      .map((code) =>
          numericCodeShortestLength(code, 2) *
          int.parse(code.substring(0, code.length - 1)))
      .sum;
  print(first);

  final second = codes
      .map((code) =>
          numericCodeShortestLength(code, 25) *
          int.parse(code.substring(0, code.length - 1)))
      .sum;
  print(second);
}

int numericCodeShortestLength(String code, int depth) {
  int shortestLength = 0;
  String current = "A";
  for (final digit in code.split('')) {
    shortestLength += shortestLengthNumeric(current, digit, depth);
    current = digit;
  }
  return shortestLength;
}

int shortestLengthNumeric(String from, String to, int depth) {
  final fromPosition = getNumericDigitPosition(from);
  final toPosition = getNumericDigitPosition(to);
  final possiblePaths =
      getDirectionalCodesForNumericMovement(fromPosition, toPosition);
  return possiblePaths
      .map((path) => directionalCodeShortestLength(path, depth))
      .min;
}

int directionalCodeShortestLength(String code, int depth) {
  int shortestLength = 0;
  String current = "A";
  for (final digit in code.split('')) {
    shortestLength += shortestLengthDirectional(current, digit, depth);
    current = digit;
  }
  return shortestLength;
}

Map<(String, String, int), int> memory = {};

int shortestLengthDirectional(String from, String to, int depth) {
  if (!memory.containsKey((from, to, depth))) {
    final fromPosition = getDirectionalDigitPosition(from);
    final toPosition = getDirectionalDigitPosition(to);

    final possiblePaths =
        getDirectionalCodesForDirectionalMovement(fromPosition, toPosition);
    if (depth == 1) {
      memory[(from, to, depth)] = possiblePaths.map((path) => path.length).min;
    } else {
      memory[(from, to, depth)] = possiblePaths
          .map((path) => directionalCodeShortestLength(path, depth - 1))
          .min;
    }
  }
  return memory[(from, to, depth)]!;
}

List<String> getDirectionalCodesForNumericMovement(
    Position start, Position end) {
  return getDirectionalCodesForMovement(start, end, numericPositions);
}

List<String> getDirectionalCodesForDirectionalMovement(
        Position start, Position end) =>
    getDirectionalCodesForMovement(start, end, directionalPositions);

List<String> getDirectionalCodesForMovement(
    Position start, Position end, Set<Position> allowed) {
  final verticalMovements = List.filled(
      (end.i - start.i).abs(), start.i < end.i ? Direction.down : Direction.up);
  final horizontalMovements = List.filled((end.j - start.j).abs(),
      start.j < end.j ? Direction.right : Direction.left);
  final possibilities = [
    horizontalMovements + verticalMovements,
    verticalMovements + horizontalMovements,
  ];
  return possibilities
      .where((path) => legal(allowed, path, start))
      .map((path) => "${path.map((d) => d.toString()).join()}A")
      .toSet()
      .toList();
}

bool legal(
    Set<Position> allowedPositions, List<Direction> path, Position start) {
  Position current = start;
  for (final dir in path) {
    current = current.advance(dir);
    if (!allowedPositions.contains(current)) return false;
  }
  return true;
}
