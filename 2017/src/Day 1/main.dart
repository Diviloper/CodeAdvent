import 'dart:io';

void main() {
  second();
}

void first() {
  final input = File('Day 1/input.txt')
      .readAsStringSync()
      .split('')
      .map(int.parse)
      .toList();

  int sum = 0;
  for (int i = 0; i < input.length; ++i) {
    if (input[i] == input[(i + 1) % input.length]) {
      sum += input[i];
    }
  }
  print(sum);
}

void second() {
  final input = File('Day 1/input.txt')
      .readAsStringSync()
      .split('')
      .map(int.parse)
      .toList();

  int sum = 0;
  for (int i = 0; i < input.length; ++i) {
    if (input[i] == input[(i + input.length ~/ 2) % input.length]) {
      sum += input[i];
    }
  }
  print(sum);
}
