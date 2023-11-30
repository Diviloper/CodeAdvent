import 'dart:math';

import 'package:equatable/equatable.dart';

extension ComparableIterableExtension<T extends Comparable> on Iterable<T> {
  Tuple<int, T> getIndexOfLargestValue() {
    int largestIndex = 0;
    T largestValue = first;
    int currentIndex = 0;
    for (T value in this) {
      if (value.compareTo(largestValue) > 0) {
        largestIndex = currentIndex;
        largestValue = value;
      }
      currentIndex++;
    }
    return Tuple(largestIndex, largestValue);
  }
}

class Tuple<X, Y> extends Equatable {
  final X first;
  final Y second;

  Tuple(this.first, this.second);

  @override
  List<Object?> get props => [first, second];

  @override
  String toString() => '$first, $second';
}

class Triple<X, Y, Z> extends Equatable {
  final X first;
  final Y second;
  final Z third;

  Triple(this.first, this.second, this.third);

  @override
  List<Object?> get props => [first, second, third];

  @override
  String toString() => '$first, $second, $third';
}

class Point extends Equatable {
  final int x, y;

  Point(this.x, this.y);

  int manhattanDistance(Point other) => (x - other.x).abs() + (y - other.y).abs();

  Point merge(Point other, bool bottomLeft) =>
      bottomLeft ? Point(min(x, other.x), min(y, other.y)) : Point(max(x, other.x), max(y, other.y));

  Point operator +(Vector move) => Point(x + move.x, y + move.y);

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => '($x, $y)';
}

class Vector extends Equatable {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator *(int scalar) => Vector(x * scalar, y * scalar);

  @override
  List<Object?> get props => [x, y];
}

class Box extends Tuple<Point, Point> {
  Box(Point bottomLeft, Point topRight) : super(bottomLeft, topRight);

  Point get bottomLeft => first;

  Point get topRight => second;

  Box enlargeToInclude(Point point) => Box(bottomLeft.merge(point, true), topRight.merge(point, false));

  int get area => (topRight.x - bottomLeft.x) * (topRight.y - bottomLeft.y);
}

extension BoundingBox on Iterable<Point> {
  Box getBoundingBox() => this.fold(Box(first, first), (boundingBox, point) => boundingBox.enlargeToInclude(point));
}
