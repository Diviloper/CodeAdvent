import 'dart:io';

import 'package:double_linked_list/double_linked_list.dart';

import '../common.dart';

void main() {
  final input = File('./input.txt').readAsLinesSync();
  final polymer = input.first.split('');
  final rules = {
    for (final rule in input.skip(2))
      rule.split(' -> ').first: rule.split(' -> ').last
  };
  expandPolymer(10, DoubleLinkedList.fromIterable(polymer), rules);
  // expandPolymer(40, DoubleLinkedList.fromIterable(polymer), rules);
}

void expandPolymer(int steps, DoubleLinkedList<String> polymer, Map<String, String> rules) {
  for (int i = 0; i < steps; ++i) {
    for (var node = polymer.first; !node.isLast; node = node.next) {
      final newElement = rules['${node.content}${node.next.content}'];
      if (newElement != null) {
        node = node.insertAfter(newElement);
      }
    }
    print(polymer.content.join());
    print(polymer.content.frequencies);
  }
  final frequencies = polymer.content.frequencies;
  Tuple<String, int> mostFrequentElement = Tuple('A', 0);
  Tuple<String, int> leastFrequentElement = Tuple('A', polymer.length);
  for (final element in frequencies.keys) {
    if (frequencies[element]! > mostFrequentElement.second) {
      mostFrequentElement = Tuple(element, frequencies[element]!);
    }
    if (frequencies[element]! < leastFrequentElement.second) {
      leastFrequentElement = Tuple(element, frequencies[element]!);
    }
  }
  print(mostFrequentElement.second - leastFrequentElement.second);
}
