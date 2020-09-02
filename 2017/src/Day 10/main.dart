import 'dart:convert';
import 'dart:io';

import '../common.dart';

void main() {
  first();
  second();
}

void first() {
  final lengths = readListInt('src/Day 10/input.txt', separator: ',');
  final list = Iterable<int>.generate(256).toList();
  int currentPosition = 0;
  int skipSize = 0;
  for (final length in lengths) {
    twist(list, currentPosition, length);
    currentPosition = (currentPosition + length + skipSize++) % list.length;
  }
  print(list[0] * list[1]);
}

void second() {
  final lengths = File('src/Day 10/input.txt')
      .readAsStringSync()
      .split('')
      .map(ascii.encode)
      .map((e) => e.single)
      .followedBy([17, 31, 73, 47, 23]).toList();
  final list = Iterable<int>.generate(256).toList();
  final denseHash = knotHash(list, lengths);
  print(denseHash.map((e) => e.toRadixString(16).padLeft(2, '0')).join());
}

List<int> knotHash(List<int> input, List<int> lengths) {
  final list = List<int>.from(input);
  int currentPosition = 0;
  int skipSize = 0;
  for (int round = 0; round < 64; ++round) {
    for (final length in lengths) {
      twist(list, currentPosition, length);
      currentPosition = (currentPosition + length + skipSize++) % list.length;
    }
  }
  final denseHash = [
    for (int i = 0; i < 16; ++i)
      list
          .sublist(i * 16, (i + 1) * 16)
          .reduce((value, element) => value ^ element),
  ];
  return denseHash;
}

void twist(List<int> list, int currentPosition, int length) {
  final reversed = list
      .followedBy(list)
      .skip(currentPosition)
      .take(length)
      .toList()
      .reversed
      .toList();
  for (int i = 0; i < length; ++i) {
    list[(currentPosition + i) % list.length] = reversed[i];
  }
}
