import 'dart:io';

void main() {
  final input = File('./input.txt').readAsLinesSync();

  first(input);
  second(input);
}

void first(List<String> input) {
  int value = 50;
  int timesAtZero = 0;
  for (final line in input) {
    final direction = line.substring(0, 1);
    final number = int.parse(line.substring(1));
    if (direction == "L") {
      value -= number;
    } else {
      value += number;
    }
    value = value % 100;
    if (value == 0) {
      timesAtZero++;
    }
  }
  print(timesAtZero);
}

void second(List<String> input) {
  int previous = 50;
  int value = 50;
  int timesAtZero = 0;
  for (final line in input) {
    final direction = line.substring(0, 1);
    final number = int.parse(line.substring(1));

    final rotations = number ~/ 100;
    timesAtZero += rotations;

    if (direction == "L") {
      value -= number % 100;
    } else {
      value += number % 100;
    }

    if (previous > 0 && value < 0) timesAtZero++;
    if (value > 100) timesAtZero++;
    value = value % 100;
    if (value == 0) {
      timesAtZero++;
    }
    previous = value;
  }
  print(timesAtZero);
}
