import 'dart:io';

import 'dart:math';

void main() {
  final size = 1000;
  final lights = List.generate(size, (_) => List.filled(size, 0));
  final orders = File('input.txt').readAsLinesSync();
  final regexp = RegExp(r'^([a-z\ ]*[a-z]+)\ (\d+,\d+)\ through\ (\d+,\d+)$');
  for (final order in orders) {
    final match = regexp.allMatches(order).single;
    final action = match.group(1);
    final from = match.group(2).split(',').map(int.parse).toList();
    final to = match.group(3).split(',').map(int.parse).toList();
    switch (action) {
      case 'turn on':
        apply(lights, from[0], from[1], to[0], to[1], (x) => x + 1);
        break;
      case 'turn off':
        apply(lights, from[0], from[1], to[0], to[1], (x) => max(x - 1, 0));
        break;
      case 'toggle':
        apply(lights, from[0], from[1], to[0], to[1], (x) => x + 2);
    }
  }
  print(lights.fold<int>(0, (current, row) => current + row.reduce((x, y) => x + y)));
}

void apply(
    List<List<int>> lights, int fromX, int fromY, int toX, int toY, int Function(int) order) {
  for (int x = fromX; x <= toX; ++x) {
    for (int y = fromY; y <= toY; ++y) {
      lights[x][y] = order(lights[x][y]);
    }
  }
}
