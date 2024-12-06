import 'dart:io';

import '../common.dart';
import '../directions.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((row) => row.split(""))
      .toList();

  final initialPosition = getInitialPosition(input);
  Direction direction =
      Direction.fromString(input[initialPosition.i][initialPosition.j]);

  final path = getSeenPositions(initialPosition, direction, input);
  print(path.firsts.toSet().length);

  final loops = createLoops(input, path, initialPosition, direction);
  print(loops);
}

Position getInitialPosition(List<List<String>> input) {
  for (final (i, row) in input.indexed) {
    for (final (j, cell) in row.indexed) {
      if (cell != '.' && cell != '#') return Position.fromCoords(i, j);
    }
  }
  throw Exception("Initial Position not found");
}

List<(Position, Direction)> getSeenPositions(
    Position initialPosition, Direction direction, List<List<String>> input) {
  List<(Position, Direction)> path = [];
  Position currentPosition = initialPosition;
  while (true) {
    path.add((currentPosition, direction));

    final nextPos = currentPosition.advance(direction);
    if (input.outOfBoundsPos(nextPos)) break;
    if (input.atPosition(nextPos) == '#') {
      direction = direction.turnRight();
    } else {
      currentPosition = nextPos;
    }
  }
  return path;
}

void printMap(List<List<String>> map, Set<Position> seen) {
  for (final (i, row) in map.indexed) {
    final rowString = row.indexedMap((j, cell) {
      if (cell == '#') return cell;
      if (seen.contains(Position.fromCoords(i, j))) return "X";
      return cell;
    }).join();
    print(rowString);
  }
}

int createLoops(
  List<List<String>> map,
  List<(Position, Direction)> path,
  Position initialPosition,
  Direction initialDirection,
) {
  final currentlySeen = <(Position, Direction)>[];
  int loops = 0;
  final triedObstacles = <Position>{};

  for (final (i, (pos, dir)) in path.indexed) {
    print("$i of ${path.length}");
    final nextPos = pos.advance(dir);

    if (map.outOfBoundsPos(nextPos)) continue;
    if (triedObstacles.contains(nextPos)) continue;
    triedObstacles.add(nextPos);

    final oldValue = map.atPosition(nextPos);
    map[nextPos.i][nextPos.j] = '#';

    if (isLoop(map, pos, dir, currentlySeen)) ++loops;

    map[nextPos.i][nextPos.j] = oldValue;
    currentlySeen.add((pos, dir));
  }
  return loops;
}

bool isLoop(
  List<List<String>> map,
  Position currentPos,
  Direction currentDirection,
  List<(Position, Direction)> history,
) {
  final localHistory = history.copy();
  currentDirection = currentDirection.turnRight();
  while (true) {
    localHistory.add((currentPos, currentDirection));
    final nextPos = currentPos.advance(currentDirection);
    if (localHistory.contains((nextPos, currentDirection))) return true;
    if (map.outOfBoundsPos(nextPos)) return false;
    if (map.atPosition(nextPos) == '#') {
      currentDirection = currentDirection.turnRight();
    } else {
      currentPos = nextPos;
    }
  }
}
