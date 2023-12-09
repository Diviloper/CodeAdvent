import 'package:collection/collection.dart';

// ----------------------------------Position-----------------------------------

typedef Position = (int row, int col);

extension PositionExtended on Position {
  Iterable<Position> get neighbors sync* {
    yield (this.$1 - 1, this.$2 - 1);
    yield (this.$1 - 1, this.$2);
    yield (this.$1 - 1, this.$2 + 1);
    yield (this.$1, this.$2 - 1);
    yield (this.$1, this.$2 + 1);
    yield (this.$1 + 1, this.$2 - 1);
    yield (this.$1 + 1, this.$2);
    yield (this.$1 + 1, this.$2 + 1);
  }

  bool isAdjacent(Position other) => neighbors.any((e) => e == other);

  bool isAdjacentColumnRange(int row, int colStart, int colEnd) {
    for (int numCol = colStart; numCol <= colEnd; ++numCol) {
      if (isAdjacent((row, numCol))) {
        return true;
      }
    }
    return false;
  }
}

// -----------------------Utils for int and Iterable<int>-----------------------

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

extension Counter<T> on Iterable<T> {
  Map<T, int> get count {
    final counts = <T, int>{};
    for (final element in this) {
      counts[element] = (counts[element] ?? 0) + 1;
    }
    return counts;
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

Iterable<(F, S)> zip<F, S>(Iterable<F> first, Iterable<S> second) =>
    IterableZip([first, second]).map((e) => (e.first as F, e.last as S));

extension Zipper<F, S> on Iterable<(F, S)> {
  Iterable<T> zippedMap<T>(T Function(F first, S second) toElement) =>
      map((e) => toElement(e.$1, e.$2));

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
