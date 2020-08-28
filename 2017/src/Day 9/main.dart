import 'dart:io';

void main() {
  first();
  second();
}

void first() {
  final stream = File('src/Day 9/input.txt').readAsStringSync().split('');
  bool garbage = false;
  for (int i = 0; i < stream.length;) {
    if (stream[i] == '!') {
      stream.removeAt(i);
      stream.removeAt(i);
    } else if (garbage) {
      if (stream[i] == '>') {
        garbage = false;
      }
      stream.removeAt(i);
    } else if (stream[i] == '<') {
      garbage = true;
      stream.removeAt(i);
    } else {
      i++;
    }
  }
  stream.removeWhere((element) => element == ',');

  int depth = 0;
  int sum = 0;
  for (final element in stream) {
    if (element == '{') {
      depth++;
    } else {
      sum += depth--;
    }
  }
  print(sum);
}

void second() {
  final stream = File('src/Day 9/input.txt').readAsStringSync().split('');
  bool garbage = false;
  int removedGarbage = 0;
  for (int i = 0; i < stream.length;) {
    if (stream[i] == '!') {
      stream.removeAt(i);
      stream.removeAt(i);
    } else if (garbage) {
      if (stream[i] == '>') {
        garbage = false;
      } else {
        removedGarbage++;
      }
      stream.removeAt(i);
    } else if (stream[i] == '<') {
      garbage = true;
      stream.removeAt(i);
    } else {
      i++;
    }
  }
  print(removedGarbage);
}
