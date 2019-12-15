import 'dart:async';
import 'dart:collection';
import 'dart:io';

import '../../Common/IntCodeComputer/intCodeComputer.dart';

extension on int {
  Cell toCell() {
    switch (this) {
      case 0:
        return Cell.empty;
      case 1:
        return Cell.wall;
      case 2:
        return Cell.block;
      case 3:
        return Cell.paddle;
      case 4:
        return Cell.ball;
      default:
        return Cell.empty;
    }
  }
}

extension on Cell {
  String toStr() {
    switch (this) {
      case Cell.empty:
        return ' ';
      case Cell.wall:
        return '#';
      case Cell.block:
        return '+';
      case Cell.paddle:
        return '-';
      case Cell.ball:
        return 'O';
      default:
        return '!';
    }
  }
}

enum Cell { empty, wall, block, paddle, ball }

void main() async {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();
  final machine = IntCodeMachine();
  final int w = 44, h = 22;
  final List<List<Cell>> grid = List.generate(
    h,
    (_) => List.generate(w, (_) => Cell.empty),
  );
  machine.runProgram(program);
  await play(machine, grid, w, h);
}

Future play(IntCodeMachine machine, List<List<Cell>> grid, int w, int h) async {
  String action = 'X';
  int x, y, score;
  StreamController<int> joystick = StreamController();
  machine.streamInput = joystick.stream;
  Queue<int> queue = Queue();
  int ballX = 0, ballY, paddlePosition, ballDirection = 0;
  bool ballUpdated = false, paddleUpdated = false;
  await for (int value in machine.output.stream) {
    queue.addFirst(value);
    switch (action) {
      case 'X':
        x = value;
        action = 'Y';
        break;
      case 'Y':
        y = value;
        action = 'V';
        break;
      case 'V':
        if (x != -1 || y != 0) {
          Cell type = value.toCell();
          grid[y][x] = type;
          if (type == Cell.ball) {
            ballDirection = ballX > x ? -1 : 1;
            ballY = y;
            ballX = x;
            ballUpdated = true;
          } else if (type == Cell.paddle) {
            paddlePosition = x;
            paddleUpdated = true;
          }
        } else
          score = value;
        action = 'X';
        break;
    }
    if (ballUpdated && paddleUpdated) {
      for (var row in grid) {
        print(row.map((cell) => cell.toStr()).join());
      }
      int paddleDirection =
          getDirection(paddlePosition, ballX, ballY, ballDirection);
      joystick.add(paddleDirection);
      ballUpdated = false;
      paddleUpdated = paddleDirection == 0;
      print("Score: $score || Move paddle $paddleDirection");
    }
  }
  joystick.close();
  for (var row in grid) {
    print(row.map((cell) => cell.toStr()).join());
  }
  print("############################################");
  print("############################################");
  print("####### C O N G R A T U L A T I O N S ######");
  print("############## SCORE: $score ################");
  print("############################################");
  print("############################################");
}

int getDirection(int paddlePosition, int ballX, int ballY, int ballDirection) {
  if (ballY == 19) return ballX.compareTo(paddlePosition);
  if (paddlePosition == ballX) return ballDirection;
  if (paddlePosition > ballX) {
    if (ballDirection == -1) return -1;
    if (paddlePosition > ballX + 1)
      return -1;
    else
      return 0;
  } else {
    if (ballDirection == 1) return 1;
    if (paddlePosition < ballX - 1)
      return 1;
    else
      return 0;
  }
}
