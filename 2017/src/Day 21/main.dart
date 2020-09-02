import 'dart:io';

import 'package:equatable/equatable.dart';

void main() {
  first();
  second();
}

class Grid extends Equatable {
  final List<List<String>> grid;

  Grid(this.grid);

  Grid.merge(List<List<Grid>> grids)
      : this([
          for (final gridRow in grids)
            for (int i = 0; i < gridRow.first.grid.length; ++i)
              [for (final grid in gridRow) ...grid.grid[i]],
        ]);

  List<List<Grid>> divide() {
    final size = grid.length.isEven ? 2 : 3;
    return [
      for (int i = 0; i < grid.length ~/ size; ++i)
        [
          for (int l = 0; l < grid.length ~/ size; ++l)
            Grid([
              for (int j = 0; j < size; ++j)
                [
                  for (int k = 0; k < size; ++k)
                    grid[i * size + j][l * size + k]
                ]
            ])
        ],
    ];
  }

  int get pixelsOn {
    return grid.fold(
      0,
      (acc, nextRow) =>
          acc +
          nextRow.fold(
            0,
            (acc, nextPixel) => acc + (nextPixel == '#' ? 1 : 0),
          ),
    );
  }

  Grid flipVertically() {
    return Grid(grid.map((row) => row.reversed.toList()).toList());
  }

  Grid flipHorizontally() {
    return Grid([
      for (int i = grid.length - 1; i >= 0; --i) [...grid[i]]
    ]);
  }

  Grid rotate() {
    return Grid([
      for (int i = 0; i < grid.length; ++i)
        [
          for (int j = 0; j < grid.length; ++j) grid[grid.length - j - 1][i],
        ]
    ]);
  }

  @override
  List<Object> get props => [for (final row in grid) ...row];

  @override
  String toString() {
    return grid.map((row) => row.join()).join('\n');
  }
}

void first() {
  Grid grid = Grid(['.#.'.split(''), '..#'.split(''), '###'.split('')]);
  final lines = File('src/Day 21/input.txt')
      .readAsLinesSync()
      .map((rule) => rule.split(' => '))
      .toList();
  final rules = {
    for (final line in lines)
      Grid(line.first.split('/').map((r) => r.split('')).toList()):
          Grid(line.last.split('/').map((r) => r.split('')).toList()),
  };
  for (int i = 0; i < 5; ++i) {
    final subgrids = grid.divide();
    for (int j = 0; j < subgrids.length; ++j) {
      for (int k = 0; k < subgrids.length; ++k) {
        subgrids[j][k] = findMatch(rules, subgrids[j][k]);
      }
    }
    grid = Grid.merge(subgrids);
  }
  print(grid.pixelsOn);
}

Grid findMatch(Map<Grid, Grid> rules, Grid subgrid) {
  return rules[subgrid] ??
      rules[subgrid.flipVertically()] ??
      rules[subgrid.flipHorizontally()] ??
      rules[subgrid.rotate()] ??
      rules[subgrid.rotate().rotate()] ??
      rules[subgrid.rotate().rotate().rotate()] ??
      rules[subgrid.flipVertically().rotate()] ??
      rules[subgrid.flipHorizontally().rotate()];
}

void second() {

  Grid grid = Grid(['.#.'.split(''), '..#'.split(''), '###'.split('')]);
  final lines = File('src/Day 21/input.txt')
      .readAsLinesSync()
      .map((rule) => rule.split(' => '))
      .toList();
  final rules = {
    for (final line in lines)
      Grid(line.first.split('/').map((r) => r.split('')).toList()):
      Grid(line.last.split('/').map((r) => r.split('')).toList()),
  };
  for (int i = 0; i < 18; ++i) {
    final subgrids = grid.divide();
    for (int j = 0; j < subgrids.length; ++j) {
      for (int k = 0; k < subgrids.length; ++k) {
        subgrids[j][k] = findMatch(rules, subgrids[j][k]);
      }
    }
    grid = Grid.merge(subgrids);
  }
  print(grid.pixelsOn);
}
