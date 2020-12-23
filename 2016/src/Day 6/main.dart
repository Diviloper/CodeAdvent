import 'dart:io';

void main() {
  first();
  second();
}

String mostFrequentString(Iterable<String> strings) {
  Map<String, int> frequency = {};
  for (final string in strings) {
    frequency.update(string, (value) => value + 1, ifAbsent: () => 1);
  }
  return frequency.entries.reduce((value, element) => value.value > element.value ? value : element).key;
}

String leastFrequentString(Iterable<String> strings) {
  Map<String, int> frequency = {};
  for (final string in strings) {
    frequency.update(string, (value) => value + 1, ifAbsent: () => 1);
  }
  return frequency.entries.reduce((value, element) => value.value < element.value ? value : element).key;
}

void first() {
  final messages = File('src/Day 6/input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  print(List.generate(8, (index) => mostFrequentString(messages.map((e) => e[index]))).join());
}

void second() {
  final messages = File('src/Day 6/input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  print(List.generate(8, (index) => leastFrequentString(messages.map((e) => e[index]))).join());
}
