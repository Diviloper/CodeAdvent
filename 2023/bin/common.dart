import 'package:collection/collection.dart';

// ----------------------------------Position-----------------------------------

typedef Position = (int row, int col);

enum Direction {
  right,
  up,
  left,
  down;

  bool get isHorizontal => this == Direction.left || this == Direction.right;

  bool get isVertical => this == Direction.up || this == Direction.down;

  List<Direction> get perpendicular => isHorizontal
      ? [Direction.up, Direction.down]
      : [Direction.left, Direction.right];

  static Direction fromString(String source) => switch (source.toLowerCase()) {
        "r" => Direction.right,
        "u" => Direction.up,
        "l" => Direction.left,
        "d" => Direction.down,
        _ => throw ArgumentError.value(source),
      };
}

extension PositionExtended on Position {
  Iterable<Position> get neighbors8 sync* {
    yield (this.$1 - 1, this.$2 - 1);
    yield (this.$1 - 1, this.$2);
    yield (this.$1 - 1, this.$2 + 1);
    yield (this.$1, this.$2 - 1);
    yield (this.$1, this.$2 + 1);
    yield (this.$1 + 1, this.$2 - 1);
    yield (this.$1 + 1, this.$2);
    yield (this.$1 + 1, this.$2 + 1);
  }

  Iterable<Position> get neighbors4 sync* {
    yield (this.$1 - 1, this.$2);
    yield (this.$1, this.$2 - 1);
    yield (this.$1, this.$2 + 1);
    yield (this.$1 + 1, this.$2);
  }

  int get row => this.$1;

  int get col => this.$2;

  int get column => this.$2;

  Position get east => (this.$1, this.$2 + 1);

  Position get west => (this.$1, this.$2 - 1);

  Position get north => (this.$1 - 1, this.$2);

  Position get south => (this.$1 + 1, this.$2);

  Position move(Direction direction, [int steps = 1]) => switch (direction) {
        Direction.right => (this.$1, this.$2 + steps),
        Direction.up => (this.$1 - steps, this.$2),
        Direction.left => (this.$1, this.$2 - steps),
        Direction.down => (this.$1 + steps, this.$2)
      };

  Position operator -(Position other) =>
      (this.$1 - other.$1, this.$2 - other.$2);

  bool isAdjacent(Position other) => neighbors8.any((e) => e == other);

  bool isAdjacentColumnRange(int row, int colStart, int colEnd) {
    for (int numCol = colStart; numCol <= colEnd; ++numCol) {
      if (isAdjacent((row, numCol))) {
        return true;
      }
    }
    return false;
  }

  int manhattanDistance(Position other) {
    final diff = this - other;
    return diff.$1.abs() + diff.$2.abs();
  }

  bool isOutOfBounds(List<List<dynamic>> matrix) {
    return row < 0 ||
        row >= matrix.length ||
        col < 0 ||
        col >= matrix[row].length;
  }
}

int manhattanDistance(Position from, Position to) => from.manhattanDistance(to);

// -----------------------Utils for int and Iterable<int>-----------------------

Iterable<int> range(int to) => Iterable.generate(to, (i) => i);

extension IntExtension on int {
  int lcm(int other) => this * other ~/ gcd(other);
}

extension IntIterable on Iterable<int> {
  int get prod => fold(1, (value, element) => value * element);

  int get gcd => reduce((value, element) => value.gcd(element));

  int get lcm => reduce((value, element) => value.lcm(element));

  bool get isAllZeroes => every((element) => element == 0);
}

extension IntList on List<int> {
  List<int> get differences =>
      List.generate(length - 1, (index) => this[index + 1] - this[index]);
}

// -----------------------------Utils for Iterables-----------------------------

extension Copier<T> on List<T> {
  List<T> copy() => [for (final v in this) v];
}

extension Counter<T> on Iterable<T> {
  Map<T, int> get count {
    final counts = <T, int>{};
    for (final element in this) {
      counts[element] = (counts[element] ?? 0) + 1;
    }
    return counts;
  }
}

extension Crosser<T> on List<T> {
  Iterable<(T, T)> triangularProduct([bool includeSelf = false]) sync* {
    for (int i = 0; i < length; ++i) {
      for (int j = i + (includeSelf ? 0 : 1); j < length; ++j) {
        yield (this[i], this[j]);
      }
    }
  }
}

extension Applier<T> on Iterable<T> {
  Iterable<T> forEachThrough(void Function(T) func) => map((e) {
        func(e);
        return e;
      });
}

extension Printer<T> on Iterable<T> {
  Iterable<T> get printAll => forEachThrough(print);
}

extension Transposer<T> on List<List<T>> {
  List<List<T>> transpose() => [
        for (int i = 0; i < this[0].length; ++i)
          [
            for (int j = 0; j < length; ++j) this[j][i],
          ]
      ];

  List<List<T>> rotate() {
    final rotated = [
      for (final row in this) [for (final value in row) value]
    ];
    final n = length;
    final x = (n / 2).floor();
    final y = n - 1;
    for (int i = 0; i < x; i++) {
      for (int j = i; j < y - i; j++) {
        final k = this[i][j];
        rotated[i][j] = this[y - j][i];
        rotated[y - j][i] = this[y - i][y - j];
        rotated[y - i][y - j] = this[j][y - i];
        rotated[j][y - i] = k;
      }
    }
    return rotated;
  }
}

// -----------------------Utils for Iterables of Records------------------------

extension Mapper<F, S> on Iterable<(F, S)> {
  Map<F, S> toMap() {
    final map = <F, S>{};
    for (final (key, value) in this) {
      map[key] = value;
    }
    return map;
  }
}

Iterable<(F, S)> crossProduct<F, S>(
  Iterable<F> first,
  Iterable<S> second,
) sync* {
  for (final f in first) {
    for (final s in second) {
      yield (f, s);
    }
  }
}

Iterable<(F, S)> zip<F, S>(Iterable<F> first, Iterable<S> second) =>
    IterableZip([first, second]).map((e) => (e.first as F, e.last as S));

extension Zipper<F, S> on Iterable<(F, S)> {
  Iterable<T> zippedMap<T>(T Function(F first, S second) toElement) =>
      map((e) => toElement(e.$1, e.$2));

  Iterable<(F, S)> zippedWhere(bool Function(F first, S second) test) =>
      where((e) => test(e.$1, e.$2));

  Iterable<T> zippedExpand<T>(
    Iterable<T> Function(F first, S second) toElements,
  ) =>
      expand((element) => toElements(element.$1, element.$2));

  Iterable<F> get firsts => zippedMap((first, second) => first);

  Iterable<S> get seconds => zippedMap((first, second) => second);
}

// ---------------------------------Generators----------------------------------

Iterable<int> naturals() sync* {
  int i = 0;
  while (true) {
    yield i++;
  }
}

extension InfiniteIterable<T> on Iterable<T> {
  Iterable<T> get infinite sync* {
    while (true) {
      for (final e in this) {
        yield e;
      }
    }
  }
}
