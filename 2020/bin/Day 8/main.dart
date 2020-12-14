import 'dart:io';

void main() {
  final operations = File('./input.txt').readAsLinesSync();
  first(operations);
  second(operations);
}

void first(List<String> operations) {
  int accumulator = 0;
  int pointer = 0;
  List<bool> visited = List.filled(operations.length, false);
  while (!visited[pointer]) {
    visited[pointer] = true;
    final instruction = operations[pointer].split(' ');
    if (instruction.first == 'acc') {
      accumulator += int.parse(instruction[1]);
      ++pointer;
    } else if (instruction.first == 'jmp') {
      pointer += int.parse(instruction[1]);
    } else {
      ++pointer;
    }
  }
  print(accumulator);
}

void second(List<String> operations) {
  for (int i = 0; i < operations.length; ++i) {
    final original = operations[i];
    if (original.startsWith('nop')) {
      operations[i] = operations[i].replaceFirst('nop', 'jmp');
      final result = run(operations);
      operations[i] = original;
      if (result != null) {
        print(result);
        return;
      }
    } else if (original.startsWith('jmp')) {
      operations[i] = operations[i].replaceFirst('jmp', 'nop');
      final result = run(operations);
      operations[i] = original;
      if (result != null) {
        print(result);
        return;
      }
    }
  }
}

int run(List<String> operations) {
  int accumulator = 0;
  int pointer = 0;
  List<bool> visited = List.filled(operations.length, false);
  while (pointer >= 0 && pointer < operations.length) {
    if (visited[pointer]) return null;
    visited[pointer] = true;
    final instruction = operations[pointer].split(' ');
    if (instruction.first == 'acc') {
      accumulator += int.parse(instruction[1]);
      ++pointer;
    } else if (instruction.first == 'jmp') {
      pointer += int.parse(instruction[1]);
    } else {
      ++pointer;
    }
  }
  return accumulator;
}
