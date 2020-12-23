import 'dart:io';
import 'dart:math';
import 'package:equatable/equatable.dart';

import '../shared.dart';

class Tile extends Equatable {
  final String id;
  final List<List<String>> cells;

  Tile(this.id, this.cells);

  factory Tile.fromString(String string) {
    final lines = string.split('\r\n');
    final id = RegExp(r'^Tile (\d+):$').firstMatch(lines.first)[1];
    final cells = lines.skip(1).map((e) => e.split('')).toList();
    return Tile(id, cells);
  }

  String get topBorder => cells.first.join();

  String get bottomBorder => cells.last.join();

  String get leftBorder => cells.map((row) => row.first).join();

  String get rightBorder => cells.map((row) => row.last).join();

  Tile get rotateRight => Tile(id, cells.rotateRight);

  Tile get flipVertically => Tile(id, cells.flipVertically);

  Tile get flipHorizontally => Tile(id, cells.flipHorizontally);

  List<List<String>> get trim => cells.sublist(1, cells.length - 1).map((e) => e.sublist(1, e.length - 1)).toList();

  List<Tile> get orientations => cells.orientations.map((cellOrientation) => Tile(id, cellOrientation)).toList();

  static bool matchesHorizontally(Tile left, Tile right) => left.rightBorder == right.leftBorder;

  static bool matchesVertically(Tile top, Tile bottom) => top.bottomBorder == bottom.topBorder;

  @override
  String toString() => 'Tile $id:\n${cells.map((e) => e.join()).join('\n')}\n';

  static String idMatrix(List<List<Tile>> tiles) => tiles.map((row) => row.map((tile) => tile.id).join(' ')).join('\n');

  static String cellMatrix(List<List<Tile>> tiles) => tiles
      .map((row) => [
            for (int i = 0; i < row.first.cells.length; ++i) row.map((tile) => tile.cells[i].join()).join('  '),
          ].join('\n'))
      .join('\n\n');

  static String toMatrixString(List<List<Tile>> tiles) => '${cellMatrix(tiles)}\n\n${idMatrix(tiles)}';

  @override
  List<Object> get props => [toString()];
}

void main() {
  final tiles = File('./input.txt').readAsStringSync().split('\r\n\r\n').map((line) => Tile.fromString(line)).toList();
  first(tiles);
  second(tiles);
}

void first(List<Tile> tiles) {
  final tileOrientations = {for (final tile in tiles) tile.id: tile.orientations};
  final length = sqrt(tiles.length).toInt();
  final arrangement = List.generate(length, (_) => List<Tile>(length));
  arrange(tileOrientations, arrangement, 0, 0);
  final value = [
    arrangement.first.first.id,
    arrangement.first.last.id,
    arrangement.last.first.id,
    arrangement.last.last.id,
  ].map(int.parse).reduce((value, element) => value * element);
  print(Tile.toMatrixString(arrangement));
  print(value);
}

bool arrange(Map<String, List<Tile>> tileOrientations, List<List<Tile>> arrangement, int i, int j) {
  if (j == arrangement.length) {
    return arrange(tileOrientations, arrangement, i + 1, 0);
  }
  if (i == arrangement.length) {
    return true;
  }
  final matchesTop = (tile) => i == 0 || Tile.matchesVertically(arrangement[i - 1][j], tile);
  final matchesLeft = (tile) => j == 0 || Tile.matchesHorizontally(arrangement[i][j - 1], tile);
  final keys = tileOrientations.keys.toList();
  for (final id in keys) {
    final orientations = tileOrientations.remove(id);
    for (final orientation in orientations.where(matchesTop).where(matchesLeft)) {
      arrangement[i][j] = orientation;
      if (arrange(tileOrientations, arrangement, i, j + 1)) {
        return true;
      }
    }
    tileOrientations[id] = orientations;
  }
  arrangement[i][j] = null;
  return false;
}

void second(List<Tile> tiles) {
  final tileOrientations = {for (final tile in tiles) tile.id: tile.orientations};
  final length = sqrt(tiles.length).toInt();
  final arrangement = List.generate(length, (_) => List<Tile>(length));
  arrange(tileOrientations, arrangement, 0, 0);

  final picture = arrangement
      .map((row) => row.map((tile) => tile.trim))
      .expand((tileRow) => [for (int i = 0; i < tileRow.first.length; ++i) [...tileRow.map((tile) => tile[i])]])
      .toList();

  print(picture.toMatrixString());

  // final monster = [
  //   [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '#', ' '],
  //   ['#', ' ', ' ', ' ', ' ', '#', '#', ' ', ' ', ' ', '#', '#', ' ', ' ', ' ', ' ', '#', '#', '#'],
  //   [' ', '#', ' ', ' ', '#', ' ', ' ', '#', ' ', '#', ' ', ' ', '#', ' ', ' ', '#', ' ', ' ', ' '],
  // ];
  // final height = 3, width = 20;
  // for (final orientation in picture.orientations) {
  //   int count = 0;
  //   for (int i = 0; i < picture.length - height; ++i) {
  //     for (int j = 0; j < picture.first.length - width; ++j) {
  //       if (matches(monster, orientation.subMatrix(i, i + height, j, j + width))) {
  //         ++count;
  //       }
  //     }
  //   }
  //   print(count);
  // }
}

bool matches(List<List<String>> monster, List<List<String>> picture) {
  for (int i = 0; i < monster.length; ++i) {
    for (int j = 0; j < monster.first.length; ++j) {
      if (monster[i][j] == '#' && picture[i][j] != '#') {
        return false;
      }
    }
  }
  return true;
}
