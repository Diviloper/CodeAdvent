import 'dart:io';

import 'dart:math';

void main() {
  final cups = File('./input.txt').readAsStringSync().split('').map(int.parse).toList();
  first(cups);
  second(cups);
}

void first(List<int> cups) {
  int currentCup = cups.first;
  final maxLabel = cups.reduce(max), minLabel = cups.reduce(min);
  List<int> currentCups = List.of(cups);
  for (int i = 0; i < 100; ++i) {
    currentCups = rearrange(currentCups, currentCup);
    final removed = currentCups.sublist(1, 4);
    currentCups.removeRange(1, 4);
    int destinationCup = currentCup - 1;
    while (!currentCups.contains(destinationCup)) {
      destinationCup--;
      if (destinationCup < minLabel) destinationCup = maxLabel;
    }
    currentCups = rearrange(currentCups, nextClockwise(currentCups, destinationCup));
    currentCups.addAll(removed);
    currentCup = nextClockwise(currentCups, currentCup);
  }
  currentCups = rearrange(currentCups, 1);
  print(currentCups.skip(1).join());
}

void second(List<int> cups) {
  int currentCup = cups.first;
  int maxLabel = cups.reduce(max), minLabel = cups.reduce(min);
  List<int> currentCups =
      List.of(cups).followedBy(List.generate(100 - cups.length, (index) => index + maxLabel + 1)).toList();
  maxLabel = currentCups.reduce(max);
  for (int i = 0; i < 10; ++i) {
    currentCups = rearrange(currentCups, currentCup);
    print(currentCups.join(' '));
    final removed = currentCups.sublist(1, 4);
    currentCups.removeRange(1, 4);
    int destinationCup = currentCup - 1;
    while (!currentCups.contains(destinationCup)) {
      destinationCup--;
      if (destinationCup < minLabel) destinationCup = maxLabel;
    }
    currentCups = rearrange(currentCups, nextClockwise(currentCups, destinationCup));
    currentCups.addAll(removed);
    currentCup = nextClockwise(currentCups, currentCup);
  }
  currentCups = rearrange(currentCups, 1);
  print('${currentCups[1] * currentCups[2]}');
  print(currentCups[1] * currentCups[2]);
}

int nextClockwise(List<int> cups, int cup) => cups[(cups.indexOf(cup) + 1) % cups.length];

List<int> rearrange(List<int> cups, int start) {
  final index = cups.indexOf(start);
  return cups.skip(index).followedBy(cups.take(index)).toList();
}
