import 'dart:io';

import 'dart:math';

void main() {
  second();
}

void first() {
  final lines = File('Day 2/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('\t').map(int.parse).toList())
      .toList();
  int sum = 0;
  for (final line in lines) {
    sum += line.reduce(max) - line.reduce(min);
  }
  print(sum);
}

void second() {
  final lines = File('Day 2/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('\t').map(int.parse).toList())
      .toList();
  int sum = 0;
  for (final line in lines) {
    outer:
    for (final i in line) {
      for (final j in line) {
        if (i != j && i % j == 0) {
          sum += i ~/ j;
          break outer;
        }
      }
    }
  }
  print(sum);
}
