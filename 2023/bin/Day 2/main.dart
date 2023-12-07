import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final games =
      File('./bin/Day 2/input.txt').readAsLinesSync().map(processGame).toList();

  print(games.where((e) => isPossible(e.$2, [12, 13, 14])).firsts.sum);

  print(games.seconds.map((e) => e.prod).sum);
}

const Map<String, int> indices = {
  'red': 0,
  'green': 1,
  'blue': 2,
};

(int, List<int>) processGame(String line) {
  final parts = line.split(': ');
  final id = int.parse(parts.first.split(' ').last);
  final rounds = parts.last.split('; ');
  final colors = [0, 0, 0];
  for (final round in rounds) {
    final dices = round.split(', ').map((e) => e.split(' '));
    for (final [n, c] in dices) {
      final i = indices[c]!;
      colors[i] = max(colors[i], int.parse(n));
    }
  }
  return (id, colors);
}

bool isPossible(List<int> game, List<int> dices) {
  return game.indexed.every((element) => element.$2 <= dices[element.$1]);
}
