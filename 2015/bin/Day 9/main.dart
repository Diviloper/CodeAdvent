import 'dart:io';

import 'package:trotter/trotter.dart';

void main() {
  final input = File('input.txt').readAsLinesSync();
  final distances = <String, Map<String, int>>{};
  final regexp = RegExp(r'^([a-zA-Z]+)\ to\ ([a-zA-Z]+)\ =\ ([0-9]+)$');
  for (final line in input) {
    final match = regexp.firstMatch(line);
    final cityA = match.group(1);
    final cityB = match.group(2);
    final distance = int.parse(match.group(3));
    distances.update(
      cityA,
      (value) => value..[cityB] = distance,
      ifAbsent: () => {cityB: distance},
    );
    distances.update(
      cityB,
      (value) => value..[cityA] = distance,
      ifAbsent: () => {cityA: distance},
    );
  }
  final cities = distances.keys.toList();
  final permutations = Permutations(cities.length, cities);
  int minDistance;
  int maxDistance = 0;
  for (final sequence in permutations()) {
    final distance = getDistance(distances, sequence);
    if (minDistance == null || distance < minDistance) {
      minDistance = distance;
    }
    if (distance > maxDistance) {
      maxDistance = distance;
    }
  }
  print('Min: $minDistance\nMax: $maxDistance');
}

int getDistance(Map<String, Map<String, int>> distances, List<String> sequence) {
  int distance = 0;
  String current = sequence.first;
  for (final next in sequence.skip(1)) {
    distance += distances[current][next];
    current = next;
  }
  return distance;
}
