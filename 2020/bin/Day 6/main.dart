import 'dart:io';

void main() {
  final entries = File('./input.txt')
      .readAsStringSync()
      .split('\r\n\r\n')
      .map((e) => e.split('\r\n'))
      .toList();
  first(entries);
  second(entries);
}

void first(List<List<String>> groups) {
  final responses = groups
      .map((group) => group.expand((element) => element.split('')).toSet())
      .toList();
  print(responses.fold<int>(
      0, (previousValue, element) => previousValue + element.length));
}

void second(List<List<String>> groups) {
  final responses = groups
      .map((group) => group
          .map((person) => person.split('').toSet())
          .reduce((value, element) => value.intersection(element)))
      .toList();
  print(responses.fold<int>(
      0, (previousValue, element) => previousValue + element.length));
}
