import 'dart:io';

void main() {
  final input = File('input.txt').readAsLinesSync();
  print(input.where(isNice).length);
  print(isNice('qjhvhtzxzqqjkmpb'));
  print(isNice('xxyxx'));
  print(isNice('uurcxstgmygtbstg'));
  print(isNice('ieodomkazucvgmuy'));
}

bool isNice(String s) =>
    hasNonOverlappingRepeatingPair(s) && hasOneRepeatingLetterWithOtherBetween(s);

bool hasAtLeast3Vowels(String s) => RegExp(r'[aeiou]').allMatches(s).length >= 3;

bool hasTwoEqualConsecutiveLetters(String s) => RegExp(r'([a-z])\1+').hasMatch(s);

bool hasForbiddenSubStrings(String s) =>
    ['ab', 'cd', 'pq', 'xy'].any((forbidden) => s.contains(forbidden));

bool hasNonOverlappingRepeatingPair(String s) =>
    RegExp(r'[a-z]*([a-z]{2})[a-z]*\1[a-z]*').hasMatch(s);

bool hasOneRepeatingLetterWithOtherBetween(String s) => RegExp(r'([a-z])[a-z]\1').hasMatch(s);
