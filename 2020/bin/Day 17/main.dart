import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class BaseCoords {
  List<BaseCoords> get neighbors;
}

class Coords3D extends Equatable implements BaseCoords {
  final int x, y, z;

  const Coords3D(this.x, this.y, this.z);

  @override
  List<BaseCoords> get neighbors =>
      computeCombinations(3, [-1, 0, 1]).map((e) => Coords3D(x + e[0], y + e[1], z + e[2])).toList()..remove(this);

  @override
  List<Object> get props => [x, y, z];

  @override
  String toString() => '[$x,$y,$z]';
}

class Coords4D extends Equatable implements BaseCoords {
  final int x, y, z, w;

  Coords4D(this.x, this.y, this.z, this.w);

  @override
  List<BaseCoords> get neighbors =>
      computeCombinations(4, [-1, 0, 1]).map((e) => Coords4D(x + e[0], y + e[1], z + e[2], w + e[3])).toList()
        ..remove(this);

  @override
  List<Object> get props => [x, y, z, w];
}

class PocketDimension<Coords extends BaseCoords> {
  final Set<Coords> grid;

  PocketDimension(this.grid);

  int get activeCubes => grid.length;

  bool isActive(Coords coords) => grid.contains(coords);

  int activeNeighbors(Coords coords) =>
      coords.neighbors.map((e) => isActive(e) ? 1 : 0).reduce((value, element) => value + element);

  PocketDimension next() {
    final coordsList = {for (final coords in grid) ...coords.neighbors};
    final nextPocket = <Coords>{};
    for (final coords in coordsList) {
      int neighborsActive = activeNeighbors(coords);
      if (isActive(coords)) {
        if (neighborsActive == 2 || neighborsActive == 3) {
          nextPocket.add(coords);
        }
      } else {
        if (neighborsActive == 3) {
          nextPocket.add(coords);
        }
      }
    }
    return PocketDimension(nextPocket);
  }
}

List<List<int>> computeCombinations(int length, List<int> options) {
  List<List<int>> _computeCombinations(int length, List<int> options, List<int> previous, int index) =>
      (index == length - 1)
          ? [
              for (final option in options) [...previous, option]
            ]
          : [
              for (final option in options) ..._computeCombinations(length, options, [...previous, option], index + 1)
            ];

  return _computeCombinations(length, options, [], 0);
}

void main() {
  final grid = File('./input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  first(grid);
  second(grid);
}

void first(List<List<String>> grid) {
  final activeCoords = <Coords3D>{
    for (int i = 0; i < grid.length; ++i)
      for (int j = 0; j < grid.first.length; ++j) if (grid[i][j] == '#') Coords3D(j, -i, 0),
  };
  PocketDimension dimension = PocketDimension(activeCoords);
  for (int i = 0; i < 6; ++i) {
    print(dimension.activeCubes);
    dimension = dimension.next();
  }
  print(dimension.activeCubes);
}

void second(List<List<String>> grid) {
  final activeCoords = <Coords4D>{
    for (int i = 0; i < grid.length; ++i)
      for (int j = 0; j < grid.first.length; ++j) if (grid[i][j] == '#') Coords4D(j, -i, 0, 0),
  };
  PocketDimension dimension = PocketDimension(activeCoords);
  for (int i = 0; i < 6; ++i) {
    print(dimension.activeCubes);
    dimension = dimension.next();
  }
  print(dimension.activeCubes);
}
