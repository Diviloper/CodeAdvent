import 'dart:io';

import 'package:equatable/equatable.dart';

class Range extends Equatable {
  final int lower;
  final int upper;

  Range(this.lower, this.upper);

  factory Range.fromString(String source) {
    List<String> parts = source.split('-');
    return Range(int.parse(parts.first), int.parse(parts.last));
  }

  bool contains(Range other) => lower <= other.lower && upper >= other.upper;

  bool overlaps(Range other) =>
      lower >= other.lower && lower <= other.upper ||
      other.lower >= lower && other.lower <= upper;

  @override
  List<Object?> get props => [lower, upper];
}

void main() {
  List<List<Range>> pairRanges = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split(',').map(Range.fromString).toList())
      .toList();

  numberOfContainedPairs(pairRanges);
  numberOfOverlappingPairs(pairRanges);
}

void numberOfContainedPairs(List<List<Range>> pairRanges) {
  int count = pairRanges
      .where((element) =>
          element.first.contains(element.last) ||
          element.last.contains(element.first))
      .length;
  print(count);
}

void numberOfOverlappingPairs(List<List<Range>> pairRanges) {
  int count = pairRanges
      .where((element) => element.first.overlaps(element.last))
      .length;
  print(count);
}
