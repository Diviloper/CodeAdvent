import 'dart:io';

import '../common.dart';
import '../directions.dart';

typedef Robot = (Position, Position);

void main() {
  final robots = File('./input.txt').readAsLinesSync().map(parseRobot).toList();

  final x = 101;
  final y = 103;
  final t = 100;

  final first = robots
      .map((robot) => positionAt(robot, x, y, t))
      .map((pos) => quadrant(x, y, pos))
      .count;
  print(first[1] * first[2] * first[3] * first[4]);

  List<Robot> movingRobots = robots.copy();
  for (int i = 0; i < 10000; ++i) {
    if (hasLongHorizontalLine(movingRobots, x, y)) {
      print("------------------------------------------------------------");
      print("------------------------         $i         ----------------");
      print("------------------------------------------------------------");
      printMap(robots.map((robot) => positionAt(robot, x, y, i)).count, x, y);
      print("------------------------------------------------------------");
      print("------------------------         $i         ----------------");
      print("------------------------------------------------------------");
    }

    movingRobots =
        movingRobots.map((r) => (advance(r.$1, r.$2, x, y), r.$2)).toList();
  }
}

bool hasLongHorizontalLine(List<Robot> robots, int x, int y) {
  final pos = robots.firsts.toSet();
  int threshold = 15;

  int current;
  for (int j = 0; j < y; ++j) {
    current = 0;
    for (int i = 0; i < x; ++i) {
      if (pos.contains(Position((i, j)))) {
        ++current;
        if (current >= threshold) return true;
      } else {
        current = 0;
      }
    }
  }
  return false;
}

Robot parseRobot(String line) {
  final re = RegExp(r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)");
  final match = re.matchAsPrefix(line)!;
  final pos = Position.fromCoords(
      int.parse(match.group(1)!), int.parse(match.group(2)!));
  final speed = Position.fromCoords(
      int.parse(match.group(3)!), int.parse(match.group(4)!));
  return (pos, speed);
}

Position positionAt(Robot robot, int x, int y, int t) {
  Position pos = robot.$1;
  for (int i = 0; i < t; ++i) {
    pos = advance(pos, robot.$2, x, y);
  }
  return pos;
}

Position advance(Position pos, Position speed, int x, int y) {
  return Position.fromCoords((pos.i + speed.i) % x, (pos.j + speed.j) % y);
}

int quadrant(int x, int y, Position pos) {
  final xmid = x ~/ 2;
  final ymid = y ~/ 2;
  if (pos.i < xmid && pos.j < ymid) return 1;
  if (pos.i > xmid && pos.j < ymid) return 2;
  if (pos.i < xmid && pos.j > ymid) return 3;
  if (pos.i > xmid && pos.j > ymid) return 4;
  return 0;
}

void printMap(Counter<Position> map, int x, int y) {
  for (int j = 0; j < y; ++j) {
    final s = Iterable.generate(x, (i) => Position.fromCoords(i, j))
        .map((pos) => map[pos])
        .map((c) => c == 0 ? '.' : c.toString())
        .join();
    print(s);
  }
}
