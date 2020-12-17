import 'dart:io';

void main() {
  final startingNumbers = File('./input.txt').readAsStringSync().split(',').map(int.parse).toList();
  first(startingNumbers);
  second(startingNumbers);
}

void first(List<int> startingNumbers) {
  print(getNthNumber(startingNumbers, 2020));
}


void second(List<int> startingNumbers) {
  print(getNthNumber(startingNumbers, 30000000));
}

int getNthNumber(List<int> startingNumbers, int turns) {
  final history = <int, int>{
    for (int i = 0; i < startingNumbers.length - 1; ++i) startingNumbers[i]: i + 1,
  };
  int currentNumber = startingNumbers.last;
  for (int turn = startingNumbers.length; turn < turns; ++turn) {
    if (history.containsKey(currentNumber)) {
      int nextNumber = turn - history[currentNumber];
      history[currentNumber] = turn;
      currentNumber = nextNumber;
    } else {
      history[currentNumber] = turn;
      currentNumber = 0;
    }
  }
  return currentNumber;
}
