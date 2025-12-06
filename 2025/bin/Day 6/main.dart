import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input = File('./input.txt').readAsLinesSync();

  first(input);
  second(input);
}

void first(List<String> input) {
  final lines = input.map((line) => line.trim().split(RegExp(r"\s+"))).toList();
  final numbers = lines
      .sublist(0, lines.length - 1)
      .map((row) => row.map(int.parse).toList())
      .toList();
  final operators = lines.last;

  final rows = numbers.length;
  final columns = numbers.first.length;
  int total = 0;
  for (int i = 0; i < columns; ++i) {
    int column = numbers[0][i];
    for (int j = 1; j < rows; ++j) {
      if (operators[i] == "+") {
        column += numbers[j][i];
      } else {
        column *= numbers[j][i];
      }
    }
    total += column;
  }
  print(total);
}

void second(List<String> input) {
  final maxLength = input.map((row) => row.length).max;
  final charMatrix = input
      .map((row) => row.padRight(maxLength, " ").split("").toList())
      .toList();
  final numbers = charMatrix.sublist(0, charMatrix.length - 1);
  final operators = charMatrix.last.where((cell) => cell != " ").toList();

  int opIndex = 0;
  int total = 0;

  final columns = numbers.first.length;

  String operator = operators[opIndex];
  int problem = operator == "+" ? 0 : 1;
  for (int j = 0; j < columns; ++j) {
    String col = [for (final row in numbers) row[j]].join().trim();
    if (col == "") {
      total += problem;
      operator = operators[++opIndex];
      problem = operator == "+" ? 0 : 1;
    } else {
      if (operator == "+") {
        problem += int.parse(col);
      } else {
        problem *= int.parse(col);
      }
    }
  }
  total += problem;
  print(total);
}
