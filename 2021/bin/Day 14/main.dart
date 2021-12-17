import 'dart:io';
import 'dart:math';

import '../common.dart';

void main() {
  final input = File('./input.txt').readAsLinesSync();
  final polymer = input.first;
  final rules = {
    for (final rule in input.skip(2))
      Tuple<String, String>.fromList(rule.split(' -> ').first.split('')):
          rule.split(' -> ').last
  };
  expandPolymer(10, polymer, rules);
  expandPolymer(40, polymer, rules);
}

void expandPolymer(
  int steps,
  String polymer,
  Map<Tuple<String, String>, String> rules,
) {
  final elements = polymer.split('');
  var pairAmounts = <Tuple<String, String>, int>{};
  for (int i = 1; i < elements.length; ++i) {
    pairAmounts.update(
      Tuple(elements[i - 1], elements[i]),
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }
  for (int step = 0; step < steps; ++step) {
    final newPolymerAmounts = <Tuple<String, String>, int>{};
    for (final entry in pairAmounts.entries) {
      final pair = entry.key;
      final value = entry.value;
      final newElement = rules[pair];
      if (newElement == null) continue;
      newPolymerAmounts.update(
        Tuple(pair.first, newElement),
        (v) => v + value,
        ifAbsent: () => value,
      );
      newPolymerAmounts.update(
        Tuple(newElement, pair.second),
        (v) => v + value,
        ifAbsent: () => value,
      );
    }
    pairAmounts = newPolymerAmounts;
  }
  Map<String, int> elementFrequencies =
      getElementFrequencies(pairAmounts, elements);
  final maxFreq = elementFrequencies.values.reduce(max);
  final minFreq = elementFrequencies.values.reduce(min);
  print(maxFreq - minFreq);
}

Map<String, int> getElementFrequencies(
    Map<Tuple<String, String>, int> pairAmounts, List<String> elements) {
  final elementFrequencies = <String, int>{};
  for (final entry in pairAmounts.entries) {
    final pair = entry.key;
    final value = entry.value;
    elementFrequencies.update(
      pair.first,
      (v) => v + value,
      ifAbsent: () => value,
    );
    elementFrequencies.update(
      pair.second,
      (v) => v + value,
      ifAbsent: () => value,
    );
  }
  elementFrequencies.updateAll((key, value) => (value / 2).ceil());
  return elementFrequencies;
}
