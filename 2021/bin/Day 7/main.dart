import 'dart:io';

void main() {
  final crabPositions = File('./input.txt')
      .readAsStringSync()
      .split(',')
      .map(int.parse)
      .toList()
    ..sort();
  findPositionWithConstantFuelConsumption(crabPositions);
  findPositionWithLinearFuelConsumption(crabPositions);
}

void findPositionWithConstantFuelConsumption(List<int> crabPositions) {
  final median = crabPositions[crabPositions.length ~/ 2];
  final fuel = crabPositions.fold(0, (v, e) => v + (e - median).abs());
  print(fuel);
}

void findPositionWithLinearFuelConsumption(List<int> crabPositions) {
  final average =
      (crabPositions.reduce((v, e) => v + e) / crabPositions.length).round();
  final fuel = crabPositions
      .map((e) => (e - average).abs())
      .map((distance) => (distance * (distance + 1)) ~/ 2)
      .reduce((value, element) => value + element);
  print(fuel);
  print(crabPositions
      .map((e) => (e - average + 1).abs())
      .map((distance) => (distance * (distance + 1)) ~/ 2)
      .reduce((value, element) => value + element));
  print(crabPositions
      .map((e) => (e - average + 2).abs())
      .map((distance) => (distance * (distance + 1)) ~/ 2)
      .reduce((value, element) => value + element));
}
