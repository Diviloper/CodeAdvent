import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

Map<String, int> memory = {};

void main() {
  final input = File('./bin/Day 12/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(' '))
      .map((e) => (e.first, e.last))
      .zippedMap((springs, groups) =>
          (springs.split(''), groups.split(',').map(int.parse).toList()))
      .toList();

  print(input
      .zippedMap((first, second) => (first + ['.'], second))
      .zippedMap(getPossibleArrangements)
      .sum);

  print(input
      .zippedMap((first, second) => (
            first +
                ['?'] +
                first +
                ['?'] +
                first +
                ['?'] +
                first +
                ['?'] +
                first +
                ['.'],
            second + second + second + second + second
          ))
      .zippedMap(getPossibleArrangements)
      .sum);
}

int getPossibleArrangements(List<String> springs, List<int> damagedGroups) {
  if (damagedGroups.isEmpty) {
    return springs.any((element) => element == '#') ? 0 : 1;
  }
  if (damagedGroups.sum + damagedGroups.length - 1 > springs.length) return 0;

  final key = "${springs.join()}|${damagedGroups.join(',')}";
  if (memory.containsKey(key)) {
    return memory[key]!;
  }

  if (springs.first == '.') {
    final v = getPossibleArrangements(springs.sublist(1), damagedGroups);
    memory[key] = v;
    return v;
  } else if (springs.first == '#') {
    final group = damagedGroups.first;
    if (springs.take(group).every((e) => e == '#' || e == '?') &&
        (springs[group] == '.' || springs[group] == '?')) {
      final v = getPossibleArrangements(
          springs.sublist(group + 1), damagedGroups.sublist(1));
      memory[key] = v;
      return v;
    } else {
      memory[key] = 0;
      return 0;
    }
  } else {
    final dot = getPossibleArrangements(springs.sublist(1), damagedGroups);
    final hash =
        getPossibleArrangements(springs.copy()..[0] = '#', damagedGroups);
    memory[key] = dot + hash;
    return dot + hash;
  }
}
