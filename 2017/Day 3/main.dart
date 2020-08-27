void main() {
  first();
}

class Coords {
  final int x;
  final int y;

  Coords(this.x, this.y);

  Coords right() => Coords(x + 1, y);

  Coords left() => Coords(x - 1, y);

  Coords top() => Coords(x, y + 1);

  Coords bottom() => Coords(x - 1, y);

  int get distance => x.abs() + y.abs();
}

void first() {
  final totalSteps = 325489;
  final steps = Iterable.generate(10000).expand((element) => [element, element]);

}
