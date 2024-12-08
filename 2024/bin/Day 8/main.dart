import 'dart:io';

import '../directions.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((row) => row.split(""))
      .toList();

  final antennaLocations = input.indexed
      .expand((e) => e.$2.indexed.map((c) => ((e.$1, c.$1, c.$2))))
      .where((e) => e.$3 != ".")
      .toList();

  final frequencyMap = getFrequencyMap(antennaLocations);

  final firstAntiNodes = getAntiNodes(frequencyMap, input);
  print(firstAntiNodes.values.expand((e) => e).toSet().length);

  final secondAntiNodes = getAntiNodes(frequencyMap, input, 0, 1000);
  print(secondAntiNodes.values.expand((e) => e).toSet().length);
}

Map<String, List<Position>> getAntiNodes(
  Map<String, List<Position>> frequencyMap,
  List<List<String>> input, [
  int minFactor = 1,
  int maxFactor = 1,
]) {
  final antiNodes = <String, List<Position>>{};
  for (final MapEntry(key: freq, value: locations) in frequencyMap.entries) {
    antiNodes[freq] = [];
    for (int i = 0; i < locations.length; ++i) {
      for (int j = 0; j < locations.length; ++j) {
        if (i == j) continue;
        final dist = locations[j] - locations[i];
        int factor = minFactor;
        while (factor <= maxFactor &&
            !input.outOfBoundsPos(locations[i] - dist * factor)) {
          antiNodes[freq]!.add(locations[i] - dist * factor);
          factor++;
        }
      }
    }
  }
  return antiNodes;
}

Map<String, List<Position>> getFrequencyMap(
    List<(int, int, String)> antennaLocations) {
  final frequencyMap = <String, List<Position>>{};
  for (final (i, j, f) in antennaLocations) {
    if (!frequencyMap.containsKey(f)) frequencyMap[f] = <Position>[];
    frequencyMap[f]!.add(Position.fromCoords(i, j));
  }
  return frequencyMap;
}
