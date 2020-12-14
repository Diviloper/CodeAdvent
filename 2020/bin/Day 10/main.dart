import 'dart:io';

import 'dart:math';

void main() {
  final joltages = File('./input.txt').readAsLinesSync().map(int.parse).toList();
  first(joltages);
  second(joltages);
}

void first(List<int> joltages) {
  final connections = [0, ...joltages..sort(), (joltages.reduce(max) + 3)];
  final differences = [0, 0, 0, 0];
  for (int i = 1; i < connections.length; ++i) {
    differences[connections[i] - connections[i - 1]]++;
  }
  print(differences[1] * differences[3]);
  print(differences);
}

void second(List<int> joltages) {
  joltages.sort();
  final connections = [0, ...joltages, joltages.reduce(max) + 3];
  final differences = List.generate(connections.length - 1, (index) => connections[index + 1] - connections[index]);
  final grouped = differences
      .join()
      .split(RegExp(r'(^3+)|(13+)'))
      .where((element) => element.isNotEmpty)
      .map((e) => e.split('').map(int.parse).toList())
      .toList();
  print(grouped.map((e) => possibleCombinations(e.length)).reduce((value, element) => value * element));
}

int possibleCombinations(int length) {
  return {
    1: 2,
    2: 4,
    3: 7,
  }[length];
}
