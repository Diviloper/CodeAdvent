import 'dart:io';

void main() {
  first();
  second();
}

class Processor {
  Map<String, int> registers = {
    for (int i = 'a'.codeUnitAt(0); i <= 'h'.codeUnitAt(0); ++i)
      String.fromCharCode(i): 0,
  };

  Processor({bool debugMode = true}) {
    if (!debugMode) {
      registers['a'] = 1;
    }
  }

  int runInstruction(String instruction) {
    final parts = instruction.split(' ');
    switch (parts[0]) {
      case 'set':
        registers[parts[1]] = int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'add':
        registers[parts[1]] += int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'sub':
        registers[parts[1]] -= int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'mul':
        registers[parts[1]] *= int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'mod':
        registers[parts[1]] %= int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'jnz':
        if ((int.tryParse(parts[1]) ?? registers[parts[1]]) != 0) {
          return int.tryParse(parts[2]) ?? registers[parts[2]];
        }
    }
    return 1;
  }
}

void first() {
  final instructions = File('src/Day 23/input.txt').readAsLinesSync();
  final processor = Processor();
  int current = 0;
  int count = 0;
  while (current >= 0 && current < instructions.length) {
    if (instructions[current].startsWith('mul')) ++count;
    current += processor.runInstruction(instructions[current]);
  }
  print(count);
}

void second() {
  int a = 1, b = 0, c = 0, d = 0, e = 0, f = 0, h = 0;

  b = 108100;
  c = 125100;
  do {
    f = 1;
    d = 2;
    do {
      if (b % d == 0) f = 0;
      d += 1;
    } while (d != b);
    if (f == 0) {
      h += 1;
    }
    if (b == c) {
      print(h);
      return;
    }
    b += 17;
  } while (true);
}

void second2() {
  int a = 1, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
  b = 108100;
  c = 125100;
  while (true) {
    f = 1;
    d = 2;
    do {
      e = 2;
      do {
        g = d * e - b;
        if (g == 0) {
          f = 0;
        }
        e += 1;
        g = e - b;
      } while (g != 0);
      d += 1;
      g = d - b;
    } while (g != 0);
    if (f == 0) {
      h += 1;
    }
    g = b - c;
    if (g == 0) {
      print(h);
      return;
    }
    b += 17;
  }
}
