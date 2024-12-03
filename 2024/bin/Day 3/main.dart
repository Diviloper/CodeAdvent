import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input = File('./input.txt').readAsStringSync();

  int first = multiply(input);
  print(first);

  final second = activeSubstrings(input).map(multiply).sum;
  print(second);
}

List<String> activeSubstrings(String input) {
  final points = RegExp(r"(do\(\))|(don't\(\))")
      .allMatches(input)
      .map((match) => (match.group(0) == "do()", match.end));

  final substrings = <String>[];
  bool active = true;
  int start = 0;
  for (final (newActive, i) in points) {
    if (active && !newActive) {
      substrings.add(input.substring(start, i));
    }
    if (!active && newActive) {
      start = i;
    }
    active = newActive;
  }
  if (active) {
    substrings.add(input.substring(start));
  }
  return substrings;
}

int multiply(String input) {
  return RegExp(r"mul\((\d+),(\d+)\)")
      .allMatches(input)
      .map((match) => int.parse(match.group(1)!) * int.parse(match.group(2)!))
      .sum;
}
