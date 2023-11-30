import 'package:equatable/equatable.dart';

void main() {}

class Point extends Equatable {
  final int x;
  final int y;
  final int z;

  Point(this.x, this.y, this.z);

  List<Point> get possibleRotations => [
    Point(x, y, z),
    Point(x, z, y),
    Point(y, x, z),
    Point(y, z, x),
    Point(z, x, y),
    Point(z, y, x),
  ];

  @override
  List<Object?> get props => [x, y, z];
}