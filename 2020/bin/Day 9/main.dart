import 'dart:io';

import 'dart:math';

void main() {
  final numbers = File('./input.txt').readAsLinesSync().map(int.parse).toList();
  first(numbers);
  second(numbers);
}

void first(List<int> numbers) {
  for (int i = 25; i < numbers.length; ++i) {
    if (!hasSum(numbers[i], numbers.sublist(i - 25, i))) {
      print(numbers[i]);
    }
  }
}

void second(List<int> numbers) {
  int number, index;
  for (int i = 25; i < numbers.length; ++i) {
    if (!hasSum(numbers[i], numbers.sublist(i - 25, i))) {
      number = numbers[i];
      index = i;
    }
  }
  for (int i = 0; i < index; ++i) {
    for (int j = i + 1; j < index; ++j) {
      final sublist = numbers.sublist(i, j);
      if (sublist.reduce((value, element) => value + element) == number) {
        print(sublist.reduce(max) + sublist.reduce(min));
      }
    }
  }
}

bool hasSum(int result, List<int> options) {
  for (int i = 0; i < options.length; ++i) {
    for (int j = i + 1; j < options.length; ++j) {
      if (options[i] + options[j] == result) return true;
    }
  }
  return false;
}
