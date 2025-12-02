import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

void main() {
  final input = File('./input.txt')
      .readAsStringSync()
      .split(",")
      .map((range) => (range.split("-")[0], range.split("-")[1]))
      .toList();

  first(input);
  second(input);
}

void first(List<(String, String)> ranges) {
  print(ranges.map((r) => getInvalidInRange(r.$1, r.$2)).map((l) => l.sum).sum);
}

List<int> getInvalidInRange(String start, String end) {
  final invalids = <int>[];
  final startValue = int.parse(start);
  final endValue = int.parse(end);

  final (startLeft, startRight) = splitAt(start);
  final (endLeft, endRight) = splitAt(end, startRight.toString().length);

  for (int left = startLeft; left <= endLeft; ++left) {
    int value = int.parse('$left$left');
    if (value >= startValue && value <= endValue) invalids.add(value);
  }
  return invalids;
}

(int, int) splitAt(String value, [int? chars]) {
  chars ??= (value.length / 2).ceil();
  return (
    int.tryParse(value.substring(0, value.length - chars)) ?? 0,
    int.tryParse(value.substring(value.length - chars)) ?? 0,
  );
}

void second(List<(String, String)> ranges) {
  print(
    ranges
        .map((r) => getArbitraryInvalidInRange(r.$1, r.$2))
        .map((l) => l.sum)
        .sum,
  );
}

List<int> getArbitraryInvalidInRange(String start, String end) {
  final invalids = <int>{};
  final startValue = int.parse(start);
  final endValue = int.parse(end);

  for (int l = start.length; l <= end.length; ++l) {
    invalids.addAll(
      possibleIdsOfLength(
        l,
      ).map(int.parse).where((id) => id >= startValue && id <= endValue),
    );
  }
  return invalids.toList();
}

Iterable<String> possibleIdsOfLength(int length) sync* {
  for (int pieceLength = 1; pieceLength <= length ~/ 2; ++pieceLength) {
    if (length % pieceLength != 0) continue;
    final repetitions = length ~/ pieceLength;
    for (
      int i = pow(10, pieceLength - 1).floor();
      i < pow(10, pieceLength).floor();
      ++i
    ) {
      yield "$i" * repetitions;
    }
  }
}