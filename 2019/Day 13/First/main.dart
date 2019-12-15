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
  String action = 'X';
  int x, y;
  await for (int value in machine.output.stream) {
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
        grid[y][x] = value.toCell();
        action = 'X';
        break;
    }
    if (x == w - 1 && y == h - 1) {
      for (var row in grid) {
        print(row.map((cell) => cell.toStr()).join());
      }
    }
  }
  int count = 0;
  for (var row in grid) {
    count += row.where((cell) => cell == Cell.block).length;
  }
  print("Number of block tiles: $count");
}
