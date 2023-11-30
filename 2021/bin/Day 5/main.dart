import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

void main() {
  final lines = File('./input.txt')
      .readAsLinesSync()
      .map((e) => Line.fromString(e))
      .toList();

  getNumberOfOverlappingFlatLinePoints(lines);
  getNumberOfOverlappingLinePoints(lines);
}

void getNumberOfOverlappingLinePoints(Iterable<Line> lines) {
  final linePoints = lines.map((e) => e.points);
  final counts = <Point, int>{};
  for (final line in linePoints) {
    for (final point in line) {
      counts.update(
        point,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
  }
  print(counts.values.where((element) => element > 1).length);
}

void getNumberOfOverlappingFlatLinePoints(Iterable<Line> lines) =>
    getNumberOfOverlappingLinePoints(lines.where((element) => element.isFlat));

class Point extends Equatable {
  final int x;
  final int y;

  Point(this.x, this.y);

  factory Point.fromString(String source) {
    final parts = source.split(',');
    return Point(int.parse(parts[0]), int.parse(parts[1]));
  }

  @override
  List<Object> get props => [x, y];

  @override
  String toString() => '[$x, $y]';
}

class Line extends Equatable {
  final Point start;
  final Point end;

  Line(this.start, this.end);

  factory Line.fromString(String source) {
    final parts = source.split(' -> ');
    return Line(Point.fromString(parts[0]), Point.fromString(parts[1]));
  }

  bool get isFlat => start.x == end.x || start.y == end.y;

  Set<Point> get points {
    final xStep = end.x.compareTo(start.x);
    final yStep = end.y.compareTo(start.y);
    final distance = max((start.x - end.x).abs(), (start.y - end.y).abs());
    return {
      for (int i = 0; i <= distance; ++i)
        Point(start.x + i * xStep, start.y + i * yStep),
    };
  }

  @override
  List<Object> get props => [start, end];

  @override
  String toString() => '$start -> $end';
}
