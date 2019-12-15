import 'dart:async';
import 'dart:io';

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
  final x, y;

  Position(this.x, this.y);

  @override
  List<Object> get props => [x, y];

  Position operator+(Direction dir) {
    switch (dir){
      case Direction.top:
        return Position(x, y+1);
      case Direction.bottom:
        return Position(x, y-1);
      case Direction.left:
        return Position(x-1, y);
      case Direction.right:
        return Position(x+1, y);
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
  Map<String, int> cellColor = {};

  EmergencyHullPaintingRobot(this.firmware);

  void startPainting() async {
    cpu.streamInput = camera.stream;
    cpu.runProgram(firmware);
    bool paint = true;
    camera.add(0);
    await for (var order in cpu.output.stream) {
      if (paint) {
        cellColor[currentPosition.toString()] = order;
      } else {
        currentDirection = currentDirection.turn(order);
        currentPosition += currentDirection;
        camera.add(cellColor[currentPosition.toString()] ?? 0);
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
  print(robot.cellColor.length);
}
