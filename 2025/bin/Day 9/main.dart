import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import '../directions.dart';

typedef Arc = (Position, Position);

Map<Position, bool> cache = <Position, bool>{};

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((row) => row.split(",").map(int.parse))
      .map((row) => Position((row.last, row.first)))
      .toList();

  first(input);
  second(input);
}

void first(List<Position> input) {
  int maximum = 0;
  for (int i = 0; i < input.length; ++i) {
    for (int j = i + 1; j < input.length; ++j) {
      final area =
          (input[i].i - input[j].i + 1).abs() *
          (input[i].j - input[j].j + 1).abs();
      if (area > maximum) maximum = area;
    }
  }
  print(maximum);
}

void second(List<Position> positions) async {
  final numChunks = max(Platform.numberOfProcessors - 4, 1);
  final chunkSize = positions.length ~/ numChunks;
  final results = await Future.wait(
    Iterable.generate(
      numChunks,
      (i) =>
          Isolate.run(() => secondChunked(positions, i * chunkSize, chunkSize)),
    ),
  );
  print(results.reduce(max));
}

int secondChunked(List<Position> positions, int start, int count) {
  int maximum = 0;
  final last = min(start + count + 1, positions.length);
  for (int i = start; i < last; ++i) {
    final a = positions[i];
    for (int j = i + 1; j < positions.length; ++j) {
      final b = positions[j];
      final newArea = area(a, b);
      if (newArea <= maximum) continue;
      if (isContained(positions, a, b)) maximum = newArea;
    }
  }
  return maximum;
}

int area(Position a, Position b) =>
    ((a.i - b.i).abs() + 1) * ((a.j - b.j).abs() + 1);

bool isContained(List<Position> input, Position first, Position second) {
  final minI = min(first.i, second.i);
  final maxI = max(first.i, second.i);
  final minJ = min(first.j, second.j);
  final maxJ = max(first.j, second.j);

  final bottomLeft = Position.fromCoords(minI, minJ);
  final bottomRight = Position.fromCoords(minI, maxJ);
  final topRight = Position.fromCoords(maxI, maxJ);
  final topLeft = Position.fromCoords(maxI, minJ);
  final corners = [bottomRight, bottomLeft, topRight, topLeft];
  bool withinInput(Position x) => isWithin(input, x);
  if (!corners.every(withinInput)) return false;

  final border = [
    for (int i = minI; i <= maxI; ++i) Position((i, minJ)),
    for (int i = minI; i <= maxI; ++i) Position((i, maxJ)),
    for (int j = minJ; j <= maxJ; ++j) Position((minI, j)),
    for (int j = minJ; j <= maxJ; ++j) Position((maxI, j)),
  ];
  return border.every(withinInput);
}

bool isWithin(List<Position> input, Position position) {
  if (!cache.containsKey(position)) {
    cache[position] = _isWithin(input, position);
  }
  return cache[position]!;
}

bool _isWithin(List<Position> input, Position position) {
  if (input.contains(position)) return true;
  int arcsBelow = 0;
  int arcsAbove = 0;
  for (int nodeIndex = 0; nodeIndex < input.length; ++nodeIndex) {
    final first = input[nodeIndex];
    final second = input[(nodeIndex + 1) % input.length];
    final previous = input[(nodeIndex - 1) % input.length];
    final next = input[(nodeIndex + 2) % input.length];

    final startJ = min(first.j, second.j);
    final endJ = max(first.j, second.j);
    final startI = min(first.i, second.i);
    final endI = max(first.i, second.i);
    if (first.i == second.i) {
      // Arc is horizontal
      if (position.j >= startJ && position.j <= endJ) {
        // Position is between start and end columns

        // Position is inside arc
        if (first.i == position.i) return true;
        if (first.i < position.i) {
          // Position is below arc
          arcsAbove++;
        } else {
          // Position is above arc
          arcsBelow++;
        }
      }
    } else {
      // Arc is vertical
      if (first.j == position.j) {
        // We only care if arc is in the same column as position
        if (position.i >= startI && position.i <= endI) {
          // Position is inside the arc
          return true;
        }
        if ((previous.j >= first.j) != (next.j >= first.j)) {
          // Previous arc comes from one side and next arc goes to the other
          // reduce the number of arcs crossed by 1 since
          // crossing the two horizontal arcs (before and after vertical)
          // counts as crossing one

          if (position.i < startI) arcsBelow -= 1;
          if (position.i > endI) arcsAbove -= 1;
        }
      }
    }
  }
  return arcsBelow.isOdd && arcsAbove.isOdd;
}
