import 'dart:io';

import 'package:equatable/equatable.dart';

class Point extends Equatable {
  final int x, y;

  Point(this.x, this.y);

  Point.zero()
      : x = 0,
        y = 0;

  @override
  List<Object> get props => [x, y];

  Point operator +(Point other) {
    return Point(this.x + other.x, this.y + other.y);
  }

  int distanceFromOrigin() {
    return this.x.abs() + this.y.abs();
  }

  bool operator <(Point other) {
    return this.distanceFromOrigin() < other.distanceFromOrigin();
  }

  String toString() {
    return "($x,$y)";
  }
}

void main() {
  final file = new File('./input.txt');
  List<String> wires = file.readAsLinesSync();
  List<Set<Point>> points = [];
  for (var wire in wires) {
    Set<Point> wirePoints = {};
    Point current = Point.zero();
    for (var segment in wire.split(',')) {
      final String dir = segment[0];
      final int steps = int.parse(segment.substring(1));
      int x = 0, y = 0;
      switch (dir) {
        case 'R':
          x = 1;
          break;
        case 'L':
          x = -1;
          break;
        case 'U':
          y = 1;
          break;
        case 'D':
          y = -1;
          break;
      }
      for (int i = 1; i <= steps; ++i) {
        current = current + Point(1 * x, 1 * y);
        wirePoints.add(current);
      }
    }
    points.add(wirePoints);
  }
  Set<Point> crosses = points[0].intersection(points[1]);
  Point closest =
      crosses.reduce((current, next) => current < next ? current : next);
  print("Crosses: ${crosses.length}");
  print("Closest: $closest");
  print("Distance: ${closest.distanceFromOrigin()}");
}
