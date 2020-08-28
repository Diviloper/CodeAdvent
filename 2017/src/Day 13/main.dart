import 'dart:io';

void main() {
  first();
  second();
}

class Layer {
  final int depth;
  final int range;
  int _scannerCurrentPosition = 0;
  bool _movingDown = true;

  Layer(this.depth, this.range);

  bool get scannerAtTop => _scannerCurrentPosition == 0;

  int get severity => depth * range;

  void advance() {
    _scannerCurrentPosition += _movingDown ? 1 : -1;
    if (_movingDown && _scannerCurrentPosition == range - 1)
      _movingDown = false;
    if (!_movingDown && _scannerCurrentPosition == 0) _movingDown = true;
  }

  void reset() {
    _scannerCurrentPosition = 0;
    _movingDown = true;
  }

  bool caughtStartingAt(int turn) {
    return (turn + depth) % ((range - 1) * 2) == 0;
  }
}

int severity(List<Layer> layers, int delay) {
  for (int i = 0; i < delay; ++i) {
    for (final layer in layers) {
      layer.advance();
    }
  }
  int severity = 0;
  for (final layer in layers) {
    for (int i = 0; i < layer.depth; ++i) layer.advance();
    if (layer.scannerAtTop) severity += layer.severity;
  }
  return severity;
}

bool caught(List<Layer> layers, int delay) {
  for (final layer in layers) {
    if (layer.caughtStartingAt(delay)) return true;
  }
  return false;
}

void first() {
  final layers = File('src/Day 13/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(': ').map(int.parse).toList())
      .map((e) => Layer(e.first, e.last))
      .toList();
  print(severity(layers, 0));
}

void second() {
  final layers = File('src/Day 13/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(': ').map(int.parse).toList())
      .map((e) => Layer(e.first, e.last))
      .toList();
  int delay = 0;
  while (caught(layers, delay)) {
    delay++;
  }
  print(delay);
}
