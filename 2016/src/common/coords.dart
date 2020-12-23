import 'package:equatable/equatable.dart';

import 'direction.dart';

class Coords extends Equatable {
  final int x;
  final int y;

  Coords(this.x, this.y);

  Coords.origin() : this(0, 0);

  Coords right() => Coords(x + 1, y);

  Coords left() => Coords(x - 1, y);

  Coords top() => Coords(x, y + 1);

  Coords bottom() => Coords(x, y - 1);

  int get distance => x.abs() + y.abs();

  Coords move(Direction direction, int steps) {
    switch (direction) {
      case Direction.north:
        return Coords(this.x, this.y + steps);
        break;
      case Direction.south:
        return Coords(this.x, this.y - steps);
        break;
      case Direction.east:
        return Coords(this.x + steps, this.y);
        break;
      case Direction.west:
        return Coords(this.x - steps, this.y);
        break;
    }
    throw 'Invalid direction';
  }

  List<Coords> get neighbors => [
        this.top(),
        this.left(),
        this.bottom(),
        this.right(),
      ];

  List<Coords> get neighborsFull => [
        this.top(),
        this.top().left(),
        this.left(),
        this.left().bottom(),
        this.bottom(),
        this.bottom().right(),
        this.right(),
        this.right().top()
      ];

  @override
  String toString() => '[$x, $y]';

  @override
  List<Object> get props => [x, y];
}
