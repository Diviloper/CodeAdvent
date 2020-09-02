import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';

void main() {
  first();
  second();
}

class SoundCard {
  int lastFrequency;
  int recoveredFrequency;
  Map<String, int> registers = {
    for (int i = 'a'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); ++i)
      String.fromCharCode(i): 0,
  };

  int runInstruction(String instruction) {
    final parts = instruction.split(' ');
    switch (parts[0]) {
      case 'snd':
        lastFrequency = registers[parts[1]];
        break;
      case 'set':
        registers[parts[1]] = int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'add':
        registers[parts[1]] += int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'mul':
        registers[parts[1]] *= int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'mod':
        registers[parts[1]] %= int.tryParse(parts[2]) ?? registers[parts[2]];
        break;
      case 'rcv':
        if (int.tryParse(parts[1]) ?? registers[parts[1]] > 0) {
          recoveredFrequency = lastFrequency;
          throw recoveredFrequency;
        }
        break;
      case 'jgz':
        if (int.tryParse(parts[1]) ?? registers[parts[1]] > 0) {
          return int.tryParse(parts[2]) ?? registers[parts[2]];
        }
    }
    return 1;
  }
}

void first() {
  final instructions = File('src/Day 18/input.txt').readAsLinesSync();
  final soundCard = SoundCard();
  int current = 0;
  try {
    while (current >= 0 && current < instructions.length) {
      current += soundCard.runInstruction(instructions[current]);
    }
  } on int catch (recovered) {
    print(recovered);
  }
}

class SoundCardPaired {
  final int id;
  final StreamController<int> _receiveBuffer = StreamController();
  StreamQueue<int> _buffer;

  SoundCardPaired partner;
  List<String> program;

  int sentMessages = 0;

  Map<String, int> registers = {
    for (int i = 'a'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); ++i)
      String.fromCharCode(i): 0,
  };

  int _currentInstruction = 0;

  SoundCardPaired(this.id) {
    _buffer = StreamQueue(_receiveBuffer.stream);
    registers['p'] = id;
  }

  void addMessage(int message) => _receiveBuffer.add(message);

  Future<int> runInstruction(String instruction) async {
    final parts = instruction.split(' ');
    switch (parts[0]) {
      case 'snd':
        print('$id: ${++sentMessages}');
        partner.addMessage(registers[parts[1]]);
        break;
      case 'set':
        registers[parts[1]] = getValue(parts[2]);
        break;
      case 'add':
        registers[parts[1]] += getValue(parts[2]);
        break;
      case 'mul':
        registers[parts[1]] *= getValue(parts[2]);
        break;
      case 'mod':
        registers[parts[1]] %= getValue(parts[2]);
        break;
      case 'rcv':
        registers[parts[1]] = await _buffer.next;
        break;
      case 'jgz':
        if (getValue(parts[1]) > 0) {
          return getValue(parts[2]);
        }
    }
    return 1;
  }

  int getValue(String value) => int.tryParse(value) ?? registers[value];

  Future<void> runProgram() async {
    while (_currentInstruction >= 0 && _currentInstruction < program.length) {
      _currentInstruction += await runInstruction(program[_currentInstruction]);
    }
  }
}

Future<void> second() async {
  final instructions = File('src/Day 18/input.txt').readAsLinesSync();
  final SoundCardPaired first = SoundCardPaired(0),
      second = SoundCardPaired(1);
  first
    ..partner = second
    ..program = instructions;
  second
    ..partner = first
    ..program = instructions;
  await Future.wait([first.runProgram(), second.runProgram()]);
  print(first.sentMessages);
}
