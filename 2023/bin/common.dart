import 'package:collection/collection.dart';

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

extension IntIterable on Iterable<int> {
  int get prod => fold(1, (value, element) => value * element);
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

Iterable<(F, S)> zip<F, S>(Iterable<F> first, Iterable<S> second) =>
    IterableZip([first, second]).map((e) => (e.first as F, e.last as S));

extension Zipper<F, S> on Iterable<(F, S)> {
  Iterable<T> zippedMap<T>(T Function(F first, S second) toElement) =>
      map((e) => toElement(e.$1, e.$2));
}
