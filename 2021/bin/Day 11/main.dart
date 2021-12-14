import 'dart:io';

import '../common.dart';

void main() {
  final octopuses = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map(int.parse).toList())
      .toList();
  getNumberOfFlashes(octopuses);
  getFirstSynchronizedFlash(octopuses);
}

void getFirstSynchronizedFlash(List<List<int>> octopuses) {
  final energies = <Tuple<int, int>, int>{};
  for (int i = 0; i < octopuses.length; ++i) {
    for (int j = 0; j < octopuses[i].length; ++j) {
      energies[Tuple(i, j)] = octopuses[i][j];
    }
  }
  int turn;
  for (turn = 1;; ++turn) {
    energies.updateAll((key, value) => value + 1);
    final flashingOctopuses =
        energies.keys.where((element) => energies[element]! > 9).toSet();
    final flashedOctopuses = <Tuple<int, int>>{};
    while (flashingOctopuses.isNotEmpty) {
      final octopus = flashingOctopuses.first;
      flashingOctopuses.remove(octopus);
      for (final neighbor in octopus.fullNeighbors) {
        if (energies.containsKey(neighbor) &&
            !flashedOctopuses.contains(neighbor) &&
            !flashingOctopuses.contains(neighbor)) {
          if (energies.update(neighbor, (value) => value + 1) > 9) {
            flashingOctopuses.add(neighbor);
          }
        }
      }
      flashedOctopuses.add(octopus);
    }
    energies.updateAll((key, value) => value > 9 ? 0 : value);
    if (flashedOctopuses.length == energies.length) {
      break;
    }
  }
  print(turn);
}

void getNumberOfFlashes(List<List<int>> octopuses) {
  final energies = <Tuple<int, int>, int>{};
  for (int i = 0; i < octopuses.length; ++i) {
    for (int j = 0; j < octopuses[i].length; ++j) {
      energies[Tuple(i, j)] = octopuses[i][j];
    }
  }
  int flashes = 0;
  for (int i = 0; i < 100; ++i) {
    energies.updateAll((key, value) => value + 1);
    final flashingOctopuses =
        energies.keys.where((element) => energies[element]! > 9).toSet();
    final flashedOctopuses = <Tuple<int, int>>{};
    while (flashingOctopuses.isNotEmpty) {
      final octopus = flashingOctopuses.first;
      flashingOctopuses.remove(octopus);
      for (final neighbor in octopus.fullNeighbors) {
        if (energies.containsKey(neighbor) &&
            !flashedOctopuses.contains(neighbor) &&
            !flashingOctopuses.contains(neighbor)) {
          if (energies.update(neighbor, (value) => value + 1) > 9) {
            flashingOctopuses.add(neighbor);
          }
        }
      }
      flashedOctopuses.add(octopus);
    }
    energies.updateAll((key, value) => value > 9 ? 0 : value);
    flashes += flashedOctopuses.length;
  }
  print(flashes);
}

extension IntTuple on Tuple<int, int> {
  List<Tuple<int, int>> get fullNeighbors => [
        Tuple(first - 1, second - 1),
        Tuple(first - 1, second),
        Tuple(first - 1, second + 1),
        Tuple(first, second - 1),
        Tuple(first, second + 1),
        Tuple(first + 1, second - 1),
        Tuple(first + 1, second),
        Tuple(first + 1, second + 1),
      ];
}
