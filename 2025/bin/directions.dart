import 'dart:math';

enum Direction {
  up,
  down,
  left,
  right;

  Direction turnRight() {
    return switch (this) {
      Direction.up => Direction.right,
      Direction.down => Direction.left,
      Direction.left => Direction.up,
      Direction.right => Direction.down,
    };
  }

  Direction turnLeft() {
    return switch (this) {
      Direction.up => Direction.left,
      Direction.down => Direction.right,
      Direction.left => Direction.down,
      Direction.right => Direction.up,
    };
  }

  Direction operator -() {
    return switch (this) {
      Direction.up => Direction.down,
      Direction.down => Direction.up,
      Direction.left => Direction.right,
      Direction.right => Direction.left,
    };
  }

  static Direction fromString(String source) {
    return switch (source) {
      '^' => Direction.up,
      '>' => Direction.right,
      'v' => Direction.down,
      '<' => Direction.left,
      _ => throw Exception("Invalid string representation"),
    };
  }

  @override
  String toString() {
    return switch (this) {
      Direction.up => "^",
      Direction.down => "v",
      Direction.left => "<",
      Direction.right => ">",
    };
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

  int manhattanDistance(Position other) =>
      (i - other.i).abs() + (j - other.j).abs();

  Position advance(Direction direction) =>
      Position(direction.advanceFrom(i, j));

  Position operator -(Position other) =>
      Position.fromCoords(i - other.i, j - other.j);

  Position operator +(Position other) =>
      Position.fromCoords(i + other.i, j + other.j);

  Position operator *(int factor) =>
      Position.fromCoords(i * factor, j * factor);

  Position operator -() => Position.fromCoords(-i, -j);

  bool outOfBounds(int minX, int minY, int maxX, int maxY) =>
      i < minX || i >= maxX || j < minY || j >= maxY;

  Iterable<Position> fullNeighbors() sync* {
    yield Position((i - 1, j - 1));
    yield Position((i - 1, j));
    yield Position((i - 1, j + 1));
    yield Position((i, j - 1));
    yield Position((i, j + 1));
    yield Position((i + 1, j - 1));
    yield Position((i + 1, j));
    yield Position((i + 1, j + 1));
  }
}

extension PositionListOps on List<Position> {
  Iterable<int> get i => map((pos) => pos.i);

  Iterable<int> get j => map((pos) => pos.j);

  (Position, Position) get bounds => (
    Position.fromCoords(i.reduce(min), j.reduce(min)),
    Position.fromCoords(i.reduce(max), j.reduce(max)),
  );
}

extension Accessor<T> on List<List<T>> {
  T atPosition(Position p) => this[p.i][p.j];

  T atPositionSafe(Position p, T defaultValue) =>
      outOfBoundsPos(p) ? defaultValue : atPosition(p);

  void setAtPosition(Position p, T value) => this[p.i][p.j] = value;

  bool outOfBoundsPos(Position p) =>
      p.i < 0 || p.i >= length || p.j < 0 || p.j >= this[p.i].length;
}

extension PositionOps<T> on List<List<T>> {
  Iterable<Position> positions() sync* {
    for (int i = 0; i < length; ++i) {
      for (int j = 0; j < this[i].length; ++j) {
        final pos = Position.fromCoords(i, j);
        yield pos;
      }
    }
  }

  Iterable<Position> positionsWhere(bool Function(Position) test) sync* {
    for (int i = 0; i < length; ++i) {
      for (int j = 0; j < this[i].length; ++j) {
        final pos = Position.fromCoords(i, j);
        if (test(pos)) yield pos;
      }
    }
  }

  Iterable<Position> positionsValueWhere(
    bool Function(Position, T) test,
  ) sync* {
    for (int i = 0; i < length; ++i) {
      for (int j = 0; j < this[i].length; ++j) {
        final pos = Position.fromCoords(i, j);
        if (test(pos, this[i][j])) yield pos;
      }
    }
  }
}
