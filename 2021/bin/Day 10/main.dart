import 'dart:collection';
import 'dart:io';

void main() {
  final lines =
      File('./input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  getCorruptedLinesPoints(lines);
  getIncompleteLinesPoints(lines);
}

void getIncompleteLinesPoints(List<List<String>> lines) {
  final scores = lines
      .where((element) => getFirstCorruptedCharacter(element) == null)
      .map(getClosingString)
      .map(getClosingScore)
      .toList()
    ..sort();
  print(scores[scores.length ~/ 2]);
}

int getClosingScore(List<String> closingString) {
  final values = {')': 1, ']': 2, '}': 3, '>': 4};
  int score = 0;
  for (final char in closingString) {
    score *= 5;
    score += values[char]!;
  }
  return score;
}

List<String> getClosingString(List<String> start) {
  final queue = <String>[];
  for (final char in start) {
    if (isOpen(char)) {
      queue.add(char);
    } else if (isClose(char)) {
      if (matches(queue.last, char)) {
        queue.removeLast();
      }
    }
  }
  return queue.reversed.map(getMatchingClose).toList();
}

void getCorruptedLinesPoints(List<List<String>> lines) {
  final values = {')': 3, ']': 57, '}': 1197, '>': 25137};
  final corruptedValues = lines
      .map(getFirstCorruptedCharacter)
      .map((c) => values[c])
      .whereType<int>()
      .reduce((v, e) => v + e);
  print(corruptedValues);
}

String? getFirstCorruptedCharacter(List<String> line) {
  final queue = Queue<String>();
  for (final char in line) {
    if (isOpen(char)) {
      queue.addLast(char);
    } else if (isClose(char)) {
      if (matches(queue.last, char)) {
        queue.removeLast();
      } else {
        return char;
      }
    }
  }
  return null;
}

bool isOpen(String char) => ['(', '[', '{', '<'].contains(char);

bool isClose(String char) => [')', ']', '}', '>'].contains(char);

bool matches(String open, String close) =>
    ['()', '[]', '{}', '<>'].contains('$open$close');

String getMatchingClose(String char) =>
    {'(': ')', '[': ']', '{': '}', '<': '>'}[char]!;
