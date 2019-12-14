import 'dart:io';

import 'package:equatable/equatable.dart';

class FabricPiece {
  int id;
  int left;
  int top;
  int width;
  int height;

  FabricPiece.fromString(String input) {
    String line = input.replaceAll(' ', '').substring(1);
    final l1 = line.split('@');
    id = int.parse(l1[0]);
    final l2 = l1[1].split(':');
    final lims = l2[0].split(',');
    final size = l2[1].split('x');
    left = int.parse(lims[0]);
    top = int.parse(lims[1]);
    width = int.parse(size[0]);
    height = int.parse(size[1]);
  }

  List<Point> get points => [
        for (int x = left; x < left + width; ++x)
          for (int y = top; y < top + height; ++y) Point(x, y)
      ];
}

class Point extends Equatable {
  int x, y;

  @override
  List<Object> get props => [x, y];

  Point(this.x, this.y);
}

void main() {
  final fabricPieces = File("input.txt")
      .readAsLinesSync()
      .map((line) => FabricPiece.fromString(line))
      .toList();
  Map<Point, int> used = {};
  for (var piece in fabricPieces) {
    for (var point in piece.points) {
      used.update(point, (val) => val + 1, ifAbsent: () => 1);
    }
  }
  int numPointsUsedMoreThanOnce = used.values.where((v) => v > 1).length;
  print(numPointsUsedMoreThanOnce);
}
