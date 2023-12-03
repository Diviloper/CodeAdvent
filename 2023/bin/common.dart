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
