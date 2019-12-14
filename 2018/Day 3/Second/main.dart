import 'dart:io';

import 'package:equatable/equatable.dart';

class FabricPiece {
  int id;
  int left;
  int bot;
  int width;
  int height;

  int get right => left + width - 1;

  int get top => bot + height - 1;

  FabricPiece.fromString(String input) {
    String line = input.replaceAll(' ', '').substring(1);
    final l1 = line.split('@');
    id = int.parse(l1[0]);
    final l2 = l1[1].split(':');
    final lims = l2[0].split(',');
    final size = l2[1].split('x');
    left = int.parse(lims[0]);
    bot = int.parse(lims[1]);
    width = int.parse(size[0]);
    height = int.parse(size[1]);
  }

  bool notOverlaps(FabricPiece other) =>
      right < other.left ||
      left > other.right ||
      top < other.bot ||
      bot > other.top;

  bool overlaps(FabricPiece other) => !notOverlaps(other);

  List<Point> get points => [
        for (int x = left; x < left + width; ++x)
          for (int y = bot; y < bot + height; ++y) Point(x, y)
      ];
}

class Point extends Equatable {
  final int x, y;

  @override
  List<Object> get props => [x, y];

  Point(this.x, this.y);
}

void main() {
  final fabricPieces = File("input.txt")
      .readAsLinesSync()
      .map((line) => FabricPiece.fromString(line))
      .toList();
  FabricPiece nonOverlapped = null;
  for (int i = 0; i < fabricPieces.length; ++i) {
    bool valid = true;
    for (int j = 0; j < fabricPieces.length; ++j) {
      if (i == j) continue;
      if (fabricPieces[i].overlaps(fabricPieces[j])) {
        valid = false;
        break;
      }
    }
    if (valid) {
      nonOverlapped = fabricPieces[i];
      break;
    }
  }
  print(nonOverlapped.id);
}
