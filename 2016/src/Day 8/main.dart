import 'dart:io';

void main() {
  first();
  second();
}

class Screen {
  final int width;
  final int height;
  final List<List<bool>> screen;

  Screen(this.width, this.height) : screen = List.generate(height, (_) => List.filled(width, false));

  int get litPixels =>
      screen.fold(0, (count, row) => count + row.fold(0, (rowCount, cell) => rowCount + (cell ? 1 : 0)));

  void rect(int width, int height) {
    for (int i = 0; i < height; ++i) {
      for (int j = 0; j < width; ++j) {
        screen[i][j] = true;
      }
    }
  }

  void rotateRow(int row, int count) {
    final originalRow = List.from(screen[row]);
    for (int i = 0; i < width; ++i) {
      screen[row][(i + count) % width] = originalRow[i];
    }
  }

  void rotateColumn(int column, int count) {
    final originalColumn = List.from(screen.map((row) => row[column]));
    for (int i = 0; i < height; ++i) {
      screen[(i + count) % height][column] = originalColumn[i];
    }
  }

  @override
  String toString() => screen.map((row) => row.map((cell) => cell ? '#' : '.').join()).join('\n');
}

void test() {
  final screen = Screen(7, 3);
  print(screen);
  print('');
  screen.rect(3, 2);
  print(screen);
  print('');
  screen.rotateColumn(1, 1);
  print(screen);
  print('');
  screen.rotateRow(0, 4);
  print(screen);
  print('');
  screen.rotateColumn(1, 1);
  print(screen);
  print('');
}

void first() {
  final instructions = File('src/Day 8/input.txt').readAsLinesSync();
  final screen = Screen(50, 6);
  final rect = RegExp(r'^rect (\d+)x(\d+)$');
  final row = RegExp(r'^rotate row y=(\d+) by (\d+)$');
  final column = RegExp(r'^rotate column x=(\d+) by (\d+)$');
  for (final instruction in instructions) {
    if (rect.hasMatch(instruction)) {
      final match = rect.firstMatch(instruction);
      screen.rect(int.parse(match[1]), int.parse(match[2]));
    } else if (row.hasMatch(instruction)) {
      final match = row.firstMatch(instruction);
      screen.rotateRow(int.parse(match[1]), int.parse(match[2]));
    } else if (column.hasMatch(instruction)) {
      final match = column.firstMatch(instruction);
      screen.rotateColumn(int.parse(match[1]), int.parse(match[2]));
    }
  }
  print(screen.litPixels);
}

void second() {
  final instructions = File('src/Day 8/input.txt').readAsLinesSync();
  final screen = Screen(50, 6);
  final rect = RegExp(r'^rect (\d+)x(\d+)$');
  final row = RegExp(r'^rotate row y=(\d+) by (\d+)$');
  final column = RegExp(r'^rotate column x=(\d+) by (\d+)$');
  for (final instruction in instructions) {
    if (rect.hasMatch(instruction)) {
      final match = rect.firstMatch(instruction);
      screen.rect(int.parse(match[1]), int.parse(match[2]));
    } else if (row.hasMatch(instruction)) {
      final match = row.firstMatch(instruction);
      screen.rotateRow(int.parse(match[1]), int.parse(match[2]));
    } else if (column.hasMatch(instruction)) {
      final match = column.firstMatch(instruction);
      screen.rotateColumn(int.parse(match[1]), int.parse(match[2]));
    }
  }
  print(screen);
}
