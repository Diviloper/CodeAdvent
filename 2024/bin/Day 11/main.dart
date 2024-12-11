import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input =
      File('./input.txt').readAsStringSync().split(' ').map(int.parse).toList();

  final first = input.map((stone) => blinkAmount(stone, 25)).sum;
  print(first);

  final second = input.map((stone) => blinkAmount(stone, 75)).sum;
  print(second);
}

Map<(int, int), int> memory = {};

int blinkAmount(int stone, int times) {
  if (!memory.containsKey((stone, times))) {
    if (times == 1) {
      memory[(stone, times)] = blinkStone(stone).length;
    } else {
      memory[(stone, times)] =
          blinkStone(stone).map((s) => blinkAmount(s, times - 1)).sum;
    }
  }
  return memory[(stone, times)]!;
}

List<int> blinkStone(int stone) {
  if (stone == 0) return [1];
  final str = stone.toString();
  if (str.length.isEven) {
    final half = str.length ~/ 2;
    return [
      int.parse(str.substring(0, half)),
      int.parse(str.substring(half)),
    ];
  }
  return [stone * 2024];
}
