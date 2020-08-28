import 'dart:io';

void main() {
  first();
  second();
}

void first() {
  final lines = File('src/Day 4/input.txt').readAsLinesSync();
  int count = 0;
  for (final line in lines) {
    final words = line.split(' ');
    if (words.length == words.toSet().length) {
      count++;
    }
  }
  print(count);
}

void second() {
  final lines = File('src/Day 4/input.txt').readAsLinesSync().map((e) => e.split(' ')).toList();
  int count = 0;
  for (final line in lines) {
    bool valid = true;
    for (int i=0; i<line.length; ++i) {
      for (int j=i+1; j<line.length; ++j) {
        if (isAnagram(line[i], line[j])) {
          valid = false;
        }
      }
    }
    if (valid) ++count;
  }
  print(count);
}

bool isAnagram(String first, String second) {
  if (first.length != second.length) return false;
  final firstLetters = first.split('')..sort();
  final secondLetters = second.split('')..sort();
  for (int i = 0; i < firstLetters.length; ++i) {
    if (firstLetters[i] != secondLetters[i]) {
      return false;
    }
  }
  return true;
}
