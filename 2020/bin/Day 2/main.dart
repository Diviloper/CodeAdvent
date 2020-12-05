import 'dart:io';

void main() {
  final entries = File('./input.txt').readAsLinesSync();
  first(entries);
  second(entries);
}

void first(List<String> entries) {
  int count = 0;
  final regexp = RegExp(r'(\d+)-(\d+) ([a-z]): ([a-z]+)');
  for (final entry in entries) {
    final match = regexp.firstMatch(entry);
    final min = int.parse(match[1]);
    final max = int.parse(match[2]);
    final letter = match[3];
    final password = match[4];
    final letterCount = password
        .split('')
        .where((element) => element == letter)
        .toList()
        .length;
    if (letterCount >= min && letterCount <= max) ++count;
  }
  print(count);
}

void second(List<String> entries) {
  int count = 0;
  final regexp = RegExp(r'(\d+)-(\d+) ([a-z]): ([a-z]+)');
  for (final entry in entries) {
    final match = regexp.firstMatch(entry);
    final first = int.parse(match[1]);
    final second = int.parse(match[2]);
    final letter = match[3];
    final password = match[4];
    if (password[first - 1] == letter && password[second - 1] != letter ||
        password[first - 1] != letter && password[second - 1] == letter) {
      ++count;
    }
  }
  print(count);
}
