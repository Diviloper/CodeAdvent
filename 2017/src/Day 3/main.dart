import '../common.dart';

void main() {
  second();
}

void first() {
  final totalSteps = 325489 - 1;
  int stepsDone = 0;
  Coords coords = Coords(0, 0);
  final moves = [(Coords c) => c.right(), (Coords c) => c.top(), (Coords c) => c.left(), (Coords c) => c.bottom()];
  int move = 0;
  final steps = Iterable.generate(10000).skip(1).expand((element) => [element, element]);
  outer:
  for (final step in steps) {
    for (int i = 0; i < step; ++i) {
      if (stepsDone == totalSteps) {
        break outer;
      } else {
        stepsDone++;
        coords = moves[move % 4](coords);
      }
    }
    move++;
  }
  print(coords.distance);
}

void second() {
  final value = 325489;
  final Map<Coords, int> cells = {Coords(0, 0): 1};
  Coords coords = Coords(0, 0);
  final moves = [(Coords c) => c.right(), (Coords c) => c.top(), (Coords c) => c.left(), (Coords c) => c.bottom()];
  int move = 0;
  final steps = Iterable.generate(10000).skip(1).expand((element) => [element, element]);
  outer:
  for (final step in steps) {
    for (int i = 0; i < step; ++i) {
      if (cells[coords] > value) {
        break outer;
      } else {
        coords = moves[move % 4](coords);
        cells[coords] = coords.neighborsFull.map((e) => cells[e]).where((e) => e != null).reduce((a, b) => a+b);
      }
    }
    move++;
  }
  print(cells[coords]);
}
