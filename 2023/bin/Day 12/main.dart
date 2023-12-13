import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final input = File('./bin/Day 12/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(' '))
      .map((e) => (e.first, e.last))
      .zippedMap((springs, groups) =>
          (springs.split(''), groups.split(',').map(int.parse).toList()))
      .toList();

  print(input.zippedMap(getPossibleArrangements).sum);

  print(input
      .zippedMap((first, second) => (
            first + first + first + first + first,
            second + second + second + second + second
          ))
      .zippedMap(getPossibleArrangements)
      .printAll
      .sum);
}

int getPossibleArrangements(List<String> springs, List<int> damagedGroups) {
  return getPossibleArrangementsRecursive(springs, damagedGroups, 0);
}

int getPossibleArrangementsRecursive(
    List<String> springs, List<int> damagedGroups, int index) {
  if (index == springs.length) {
    return matchesPrefix(springs, damagedGroups) ? 1 : 0;
  }
  if (springs[index] != '?') {
    return getPossibleArrangementsRecursive(springs, damagedGroups, index + 1);
  }

  springs[index] = '.';
  final functional = matchesPrefix(springs, damagedGroups)
      ? getPossibleArrangementsRecursive(springs, damagedGroups, index + 1)
      : 0;
  springs[index] = '#';
  final damaged = matchesPrefix(springs, damagedGroups)
      ? getPossibleArrangementsRecursive(springs, damagedGroups, index + 1)
      : 0;
  springs[index] = '?';
  return functional + damaged;
}

bool matches(List<String> springs, List<int> damagedGroups) {
  final groups = springs
      .join()
      .split('.')
      .where((element) => element.isNotEmpty)
      .map((e) => e.length)
      .toList();
  return ListEquality().equals(groups, damagedGroups);
}

bool matchesPrefix(List<String> springs, List<int> damagedGroups) {
  final springString = springs.join();
  final pattern = damagedGroups.map((e) => "[?#]{$e}").join(r"[.?]+");
  final regexp = RegExp("^[.?]*$pattern[.?]*\$");
  return regexp.hasMatch(springString);
}

int allMatches(List<String> springs, List<int> damagedGroups) {
  final springString = springs.join();
  final pattern = damagedGroups.map((e) => "[?#]{$e}").join(r"[.?]+");
  final regexp = RegExp("(?=(^[.?]*$pattern[.?]*\$))");
  return regexp.allMatches(springString).length;
}
