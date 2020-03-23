import 'dart:io';

import 'dart:math';

void main() {
  final liters = 150;
  final containers = File('input.txt').readAsLinesSync().map(int.parse).toList();
  bool adds(List<bool> usedContainers) {
    int sum = 0;
    for (int i = 0; i < usedContainers.length; ++i) {
      sum += usedContainers[i] ? containers[i] : 0;
    }
    return sum == liters;
  }

  final possibilities = getPossibilities(containers.length);
  final viable = possibilities.where(adds);
  final minimum = viable.fold<int>(
    containers.length,
    (minimum, current) => min(minimum, current.where((i) => i).length),
  );
  print(viable.where((combination) => combination.where((i) => i).length == minimum).length);
}

List<List<bool>> getPossibilities(int length) {
  final possibilities = <List<bool>>[];
  _computePossibilities(possibilities, List.filled(length, false), 0);
  return possibilities;
}

void _computePossibilities(List<List<bool>> currentPossibilities, List<bool> current, int index) {
  if (index == current.length) {
    currentPossibilities.add(List.from(current));
    return;
  }
  current[index] = false;
  _computePossibilities(currentPossibilities, current, index + 1);
  current[index] = true;
  _computePossibilities(currentPossibilities, current, index + 1);
}
