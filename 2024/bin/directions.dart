enum Direction {
  up,
  down,
  left,
  right;

  Direction turnRight() {
    switch (this) {
      case Direction.up:
        return Direction.right;
      case Direction.down:
        return Direction.left;
      case Direction.left:
        return Direction.up;
      case Direction.right:
        return Direction.down;
    }
  }

  Direction turnLeft() {
    switch (this) {
      case Direction.up:
        return Direction.left;
      case Direction.down:
        return Direction.right;
      case Direction.left:
        return Direction.down;
      case Direction.right:
        return Direction.up;
    }
  }

  static Direction fromString(String source) {
    switch (source) {
      case '^':
        return Direction.up;
      case '>':
        return Direction.right;
      case 'v':
        return Direction.down;
      case '<':
        return Direction.left;
      default:
        throw Exception("Invalid string representation");
    }
  }

  (int, int) advanceFrom(int i, int j) {
    switch (this) {
      case Direction.up:
        return (i - 1, j);
      case Direction.down:
        return (i + 1, j);
      case Direction.left:
        return (i, j - 1);
      case Direction.right:
        return (i, j + 1);
    }
  }
}

extension type Position((int, int) coords) {
  factory Position.fromCoords(int i, int j) => Position((i, j));

  int get i => coords.$1;

  int get j => coords.$2;

  Position advance(Direction direction) =>
      Position(direction.advanceFrom(i, j));

  Position operator -(Position other) =>
      Position.fromCoords(i - other.i, j - other.j);

  Position operator +(Position other) =>
      Position.fromCoords(i + other.i, j + other.j);

  Position operator *(int factor) =>
      Position.fromCoords(i * factor, j * factor);

  Position operator -() => Position.fromCoords(-i, -j);
}

extension Accessor<T> on List<List<T>> {
  T atPosition(Position p) => this[p.i][p.j];

  bool outOfBoundsPos(Position p) =>
      p.i < 0 || p.i >= length || p.j < 0 || p.j >= this[p.i].length;
}

extension PositionOps<T> on List<List<T>> {
  Iterable<Position> positionsWhere(bool Function(Position) test) sync* {
    for (int i = 0; i < length; ++i) {
      for (int j = 0; j < this[i].length; ++j) {
        final pos = Position.fromCoords(i, j);
        if (test(pos)) yield pos;
      }
    }
  }
}
