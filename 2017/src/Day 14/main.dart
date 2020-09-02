import 'dart:convert';

import '../Day 10/main.dart';

void main() {
  first();
  second();
}

void first() {
  final input = 'xlqgujun';
  int count = 0;
  for (int i = 0; i < 128; ++i) {
    final key = '$input-$i';
    final lengths = key
        .split('')
        .map(ascii.encode)
        .map((e) => e.single)
        .followedBy([17, 31, 73, 47, 23]).toList();
    final list = Iterable<int>.generate(256).toList();
    final denseHash = knotHash(list, lengths);
    final binary =
        denseHash.map((e) => e.toRadixString(2).padLeft(8, '0')).join();
    count += '1'.allMatches(binary).length;
  }
  print(count);
}

void second() {
  final List<List<int>> grid = [];
  final input = 'xlqgujun';
  for (int i = 0; i < 128; ++i) {
    final key = '$input-$i';
    final lengths = key
        .split('')
        .map(ascii.encode)
        .map((e) => e.single)
        .followedBy([17, 31, 73, 47, 23]).toList();
    final list = Iterable<int>.generate(256).toList();
    final denseHash = knotHash(list, lengths);
    grid.add(
      denseHash
          .expand((e) => e.toRadixString(2).padLeft(8, '0').split(''))
          .map(int.parse)
          .toList(),
    );
  }
  int groups = 0;
  for (int i = 0; i < grid.length; ++i) {
    for (int j = 0; j < grid.first.length; ++j) {
      if (grid[i][j] == 0)
        continue;
      else {
        groups++;
        expandGroup(grid, i, j);
      }
    }
  }
  print(groups);
}

void expandGroup(List<List<int>> grid, int i, int j) {
  grid[i][j] = 0;
  final l = grid.length - 1;
  if (i > 0 && grid[i - 1][j] == 1) expandGroup(grid, i - 1, j);
  if (i < l && grid[i + 1][j] == 1) expandGroup(grid, i + 1, j);
  if (j > 0 && grid[i][j - 1] == 1) expandGroup(grid, i, j - 1);
  if (j < l && grid[i][j + 1] == 1) expandGroup(grid, i, j + 1);
}
