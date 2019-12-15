import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

import '../../Common/IntCodeComputer/intCodeComputer.dart';

enum Direction { top, bottom, right, left }

extension on Direction {
  Direction turn(int x) {
    switch (this) {
      case Direction.top:
        return x == 0 ? Direction.left : Direction.right;
      case Direction.bottom:
        return x == 0 ? Direction.right : Direction.left;
      case Direction.right:
        return x == 0 ? Direction.top : Direction.bottom;
      case Direction.left:
        return x == 0 ? Direction.bottom : Direction.top;
      default:
        throw Exception();
    }
  }
}

class Position extends Equatable {
  final int x, y;

  Position(this.x, this.y);

  @override
  List<Object> get props => [x, y];

  Position operator +(Direction dir) {
    switch (dir) {
      case Direction.top:
        return Position(x, y + 1);
      case Direction.bottom:
        return Position(x, y - 1);
      case Direction.left:
        return Position(x - 1, y);
      case Direction.right:
        return Position(x + 1, y);
      default:
        throw Exception();
    }
  }

  String toString() => "$x:$y";
}

class EmergencyHullPaintingRobot {
  final List<int> firmware;
  IntCodeMachine cpu = IntCodeMachine();
  Direction currentDirection = Direction.top;
  Position currentPosition = Position(0, 0);
  StreamController<int> camera = StreamController();
  Map<Position, int> cellColor = {};

  EmergencyHullPaintingRobot(this.firmware);

  void startPainting() async {
    cpu.streamInput = camera.stream;
    cpu.runProgram(firmware);
    bool paint = true;
    camera.add(1);
    await for (var order in cpu.output.stream) {
      if (paint) {
        cellColor[currentPosition] = order;
      } else {
        currentDirection = currentDirection.turn(order);
        currentPosition += currentDirection;
        camera.add(cellColor[currentPosition] ?? 0);
      }
      paint = !paint;
    }
  }
}

void main() async {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();
  final robot = EmergencyHullPaintingRobot(program);
  await robot.startPainting();
  showPainting(robot);
}

void showPainting(EmergencyHullPaintingRobot robot) {
  final paintedPositions = robot.cellColor.keys.toList();
  final List<int> paintedXs = paintedPositions.map((pos) => pos.x).toList();
  final List<int> paintedYs = paintedPositions.map((pos) => pos.y).toList();
  final int minX = paintedXs.reduce(min);
  final int maxX = paintedXs.reduce(max);
  final int minY = paintedYs.reduce(min);
  final int maxY = paintedYs.reduce(max);
  for (int i = maxY; i >= minY; --i) {
    for (int j = minX; j <= maxX; ++j) {
      final color = robot.cellColor[Position(j,i)] ?? 0;
      stdout.write(color == 0 ? ' ' : '#');
    }
    stdout.writeln();
  }
}
