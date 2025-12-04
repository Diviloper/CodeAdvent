import 'dart:io';
import '../directions.dart';

void main() {
  final input = File(
    './input.txt',
  ).readAsLinesSync().map((row) => row.split('')).toList();

  first(input);
  second(input);
}

void first(List<List<String>> input) {
  final boxPositions = input.positionsWhere((p) => input.atPosition(p) == "@");
  int accessibleBoxes = 0;
  for (final position in boxPositions) {
    final adjacentBoxes = position
        .fullNeighbors()
        .where((p) => input.atPositionSafe(p, ".") == "@")
        .length;
    if (adjacentBoxes < 4) accessibleBoxes++;
  }
  print(accessibleBoxes);
}

void second(List<List<String>> input) {
  int removedBoxes = 0;
  int accessibleBoxes = 0;
  do {
    accessibleBoxes = 0;
    final boxPositions = input.positionsWhere(
      (p) => input.atPosition(p) == "@",
    );
    for (final position in boxPositions) {
      final adjacentBoxes = position
          .fullNeighbors()
          .where((p) => input.atPositionSafe(p, ".") == "@")
          .length;
      if (adjacentBoxes < 4) {
        accessibleBoxes++;
        input.setAtPosition(position, ".");
      }
    }
    removedBoxes += accessibleBoxes;
  } while (accessibleBoxes > 0);
  print(removedBoxes);
}
