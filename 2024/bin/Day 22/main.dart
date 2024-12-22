import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final initials =
      File('./input.txt').readAsLinesSync().map(int.parse).toList();

  final first = initials.map((value) => nextTimes(value, 2000)).sum;
  print(first);

  final second = mostBananas(initials, 2000);
  print(second);
}

int nextTimes(int value, int times) {
  int result = value;
  for (int i = 0; i < times; ++i) {
    result = next(result);
  }
  return result;
}

int mostBananas(List<int> initialCodes, int times) {
  final bananasPerSequence = <(int, int, int, int), int>{};
  for (final code in initialCodes) {
    final codeBananas = bananas(code, times);
    for (final MapEntry(key: code, value: price) in codeBananas.entries) {
      if (bananasPerSequence.containsKey(code)) {
        bananasPerSequence[code] = bananasPerSequence[code]! + price;
      } else {
        bananasPerSequence[code] = price;
      }
    }
  }
  return bananasPerSequence.values.max;
}

Map<(int, int, int, int), int> bananas(int value, int times) {
  final bananasPerChanges = <(int, int, int, int), int>{};
  final changes = <int>[];
  int current = value;
  for (int i = 0; i < times; ++i) {
    final nextValue = next(current);
    changes.add((nextValue % 10) - (current % 10));
    if (changes.length > 4) changes.removeAt(0);
    if (changes.length == 4) {
      final key = (changes[0], changes[1], changes[2], changes[3]);
      if (!bananasPerChanges.containsKey(key)) {
        bananasPerChanges[key] = nextValue % 10;
      }
    }
    current = nextValue;
  }
  return bananasPerChanges;
}

int next(int value) => thirdStep(secondStep(firstStep(value)));

int firstStep(int value) => prune(mix(value, value << 6));

int secondStep(int value) => prune(mix(value, value >> 5));

int thirdStep(int value) => prune(mix(value, value << 11));

int mix(int a, int b) => a ^ b;

int prune(int value) => value & 0x0FFFFFF;
