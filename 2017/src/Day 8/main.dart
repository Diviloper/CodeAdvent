import 'dart:io';
import 'dart:math';

import '../common.dart';

void main() {
  first();
  second();
}

void first() {
  final lines = File('src/Day 8/input.txt').readAsLinesSync();
  final cpu = CPU();
  lines.forEach(cpu.execute);
  print(cpu.maxValue);
}

void second() {
  final lines = File('src/Day 8/input.txt').readAsLinesSync();
  final cpu = CPU();
  final maxValues = <int>[];
  for (final line in lines) {
    cpu.execute(line);
    maxValues.add(cpu.maxValue);
  }
  print(maxValues.reduce(max));
}

class CPU {
  Map<String, int> _registers = {};

  void increment(String register, int value) {
    this[register] += value;
  }

  void decrement(String register, int value) {
    this[register] -= value;
  }

  int operator [](String key) {
    if (!_registers.containsKey(key)) {
      _registers[key] = 0;
    }
    return _registers[key];
  }

  void operator []=(String key, int value) => _registers[key] = value;

  void execute(String command) {
    final parts = command.split(' ');
    if (comparator(parts[5])(this[parts[4]], int.parse(parts[6]))) {
      switch (parts[1]) {
        case 'inc':
          increment(parts[0], int.parse(parts[2]));
          break;
        case 'dec':
          decrement(parts[0], int.parse(parts[2]));
      }
    }
  }

  int get maxValue => _registers.values.reduce(max);
}
