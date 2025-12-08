import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

typedef Position3D = (int, int, int);

void main() {
  final positions = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split(",").map(int.parse).toList())
      .map((row) => (row[0], row[1], row[2]))
      .toList();

  first(positions);
  second(positions);
}

void first(List<Position3D> positions) {
  final circuits = mergeClosest(positions, 1000);
  final sizes = circuits.values.count.values.sortedBy((x) => -x).sublist(0, 3);
  print(sizes.reduce((a, b) => a * b));
}

Map<Position3D, int> mergeClosest(List<Position3D> positions, int n) {
  final connections =
      [
        for (int i = 0; i < positions.length; ++i)
          for (int j = i + 1; j < positions.length; ++j)
            (positions[i], positions[j]),
      ].sortedBy(
        (pair) => sqrt(
          pow(pair.$1.$1 - pair.$2.$1, 2) +
              pow(pair.$1.$2 - pair.$2.$2, 2) +
              pow(pair.$1.$3 - pair.$2.$3, 2),
        ),
      );
  final shortestConnections = connections.sublist(0, n);
  final circuits = <Position3D, int>{};
  int numCircuits = 0;
  for (final connection in shortestConnections) {
    final circuit1 = circuits[connection.$1];
    final circuit2 = circuits[connection.$2];
    if (circuit1 == null && circuit2 == null) {
      circuits[connection.$1] = numCircuits;
      circuits[connection.$2] = numCircuits;
      numCircuits += 1;
    } else if (circuit1 == null || circuit2 == null) {
      final circuit = circuit1 ?? circuit2!;
      circuits[connection.$1] = circuit;
      circuits[connection.$2] = circuit;
    } else {
      circuits.updateAll((key, value) => value == circuit2 ? circuit1 : value);
    }
  }
  return circuits;
}

void second(List<Position3D> connections) {
  final connection = mergeUntilSingleCircuit(connections);
  print(connection.$1.$1 * connection.$2.$1);
}

(Position3D, Position3D) mergeUntilSingleCircuit(List<Position3D> positions) {
  final connections =
  [
    for (int i = 0; i < positions.length; ++i)
      for (int j = i + 1; j < positions.length; ++j)
        (positions[i], positions[j]),
  ].sortedBy(
        (pair) => sqrt(
      pow(pair.$1.$1 - pair.$2.$1, 2) +
          pow(pair.$1.$2 - pair.$2.$2, 2) +
          pow(pair.$1.$3 - pair.$2.$3, 2),
    ),
  );
  final circuits = <Position3D, int>{};
  int nextCircuit = 0;
  (Position3D, Position3D) lastConnection = connections[0];
  for (final connection in connections) {
    final circuit1 = circuits[connection.$1];
    final circuit2 = circuits[connection.$2];
    if (circuit1 == null && circuit2 == null) {
      circuits[connection.$1] = nextCircuit;
      circuits[connection.$2] = nextCircuit;
      nextCircuit += 1;
    } else if (circuit1 == null || circuit2 == null) {
      final circuit = circuit1 ?? circuit2!;
      circuits[connection.$1] = circuit;
      circuits[connection.$2] = circuit;
    } else {
      circuits.updateAll((key, value) => value == circuit2 ? circuit1 : value);
    }
    lastConnection = connection;
    if (circuits.length == positions.length) break;
  }
  return lastConnection;

}
