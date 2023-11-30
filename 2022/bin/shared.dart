import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int x;
  final int y;

  Position(this.x, this.y);

  int distance(Position other) => xDistance(other) + yDistance(other);

  int xDistance(Position other) => (x - other.x).abs();

  int yDistance(Position other) => (y - other.y).abs();

  List<Position> neighbours() => [
        Position(x - 1, y),
        Position(x + 1, y),
        Position(x, y + 1),
        Position(x, y - 1),
      ];

  @override
  List<Object> get props => [x, y];
}

class Pair<F, S> extends Equatable {
  final F first;
  final S second;

  Pair(this.first, this.second);

  @override
  List<dynamic> get props => [first, second];
}
