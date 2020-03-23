import 'dart:io';

void main() {
  List<List<bool>> grid = File('input.txt')
      .readAsLinesSync()
      .map(
        (row) => row.split('').map((char) => char == '#').toList(),
      )
      .toList();
  final steps = 100;
  final size = grid.length;
  for (int step = 0; step < steps; ++step) {
    final next = List.generate(size, (_) => List.filled(size, false));
    for (int i = 0; i < size; ++i) {
      for (int j = 0; j < size; ++j) {
        int onNeighbours = getNeighbourOn(grid, i, j);
        if (grid[i][j]) {
          next[i][j] = onNeighbours == 2 || onNeighbours == 3;
        } else {
          next[i][j] = onNeighbours == 3;
        }
      }
    }
    printGrid(grid);
    grid = next
      ..first.first = true
      ..first.last = true
      ..last.first = true
      ..last.last = true;
  }
  print(grid.fold<int>(
    0,
    (current, row) =>
        current +
        row.fold<int>(
          0,
          (current, light) => current + light.toInt(),
        ),
  ));
}

void printGrid(List<List<bool>> grid) {
  for (final row in grid) {
    print(row.map((i) => i ? '#' : '.').join());
  }
}

int getNeighbourOn(List<List<bool>> grid, int i, int j) {
  int count = 0;
  final size = grid.length;
  if (i > 0) {
    if (j > 0) {
      count += grid[i - 1][j - 1].toInt();
    }
    count += grid[i - 1][j].toInt();
    if (j < size - 1) {
      count += grid[i - 1][j + 1].toInt();
    }
  }
  if (j > 0) {
    count += grid[i][j - 1].toInt();
  }
  if (j < size - 1) {
    count += grid[i][j + 1].toInt();
  }
  if (i < size - 1) {
    if (j > 0) {
      count += grid[i + 1][j - 1].toInt();
    }
    count += grid[i + 1][j].toInt();
    if (j < size - 1) {
      count += grid[i + 1][j + 1].toInt();
    }
  }
  return count;
}

extension on bool {
  int toInt() => this ? 1 : 0;
}
