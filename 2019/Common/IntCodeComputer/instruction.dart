import 'dart:io';
import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';

import 'intCodeComputer.dart';

abstract class Instruction {
  final IntCodeMachine machine;

  Instruction(this.machine);

  Future<int> run(List<int> program, int instructionPointer);

  int get numParams => 0;

  List<int> _getModes(int opCode, int numParams) {
    int modeNumber = opCode ~/ 100;
    List<int> modes = List<int>(numParams);
    for (int i = 0; i < numParams; ++i) {
      modes[i] = modeNumber % 10;
      modeNumber ~/= 10;
    }
    return modes;
  }

  int _getParam(List<int> program, int mode, int param) {
    switch (mode) {
      case 0:
        return program[param];
      case 1:
        return param;
      case 2:
        return program[param + machine.relativeOffset];
      default:
        throw IntCodeException("Incorrect param mode");
    }
  }

  int _getReference(int mode, int param) {
    switch (mode) {
      case 0:
        return param;
      case 2:
        return param + machine.relativeOffset;
      default:
        throw IntCodeException("Incorrect param mode");
    }
  }
}

class Addition extends Instruction {
  Addition(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 3;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    List<int> modes = _getModes(program[instructionPointer], numParams);
    program[_getReference(modes[2], program[instructionPointer + 3])] =
        _getParam(program, modes[0], program[instructionPointer + 1]) +
            _getParam(program, modes[1], program[instructionPointer + 2]);
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Multiplication extends Instruction {
  Multiplication(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 3;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    List<int> modes = _getModes(program[instructionPointer], numParams);
    program[_getReference(modes[2], program[instructionPointer + 3])] =
        _getParam(program, modes[0], program[instructionPointer + 1]) *
            _getParam(program, modes[1], program[instructionPointer + 2]);
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Read extends Instruction {
  Read(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 1;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    print("Enter value: ");
    int input = int.tryParse(stdin.readLineSync());
    while (input == null) {
      print("Value invalid. Try again: ");
      input = int.tryParse(stdin.readLineSync());
    }
    final modes = _getModes(program[instructionPointer], numParams);
    program[_getReference(modes[0], program[instructionPointer + 1])] = input;
    return program[instructionPointer + 1] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class ReadStream extends Instruction {
  final StreamQueue<int> input;

  ReadStream(IntCodeMachine machine, Stream<int> inputStream)
      : input = StreamQueue(inputStream),
        super(machine);

  @override
  int get numParams => 1;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    while (!await input.hasNext) {
      print("Waiting for input");
      await Future.delayed(Duration(milliseconds: 5));
    }
    final modes = _getModes(program[instructionPointer], numParams);
    program[_getReference(modes[0], program[instructionPointer + 1])] = await input.next;
    return program[instructionPointer + 1] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class ReadInput extends Instruction {
  final Queue<int> input;

  ReadInput(IntCodeMachine machine, this.input) : super(machine);

  @override
  int get numParams => 1;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    final modes = _getModes(program[instructionPointer], numParams);
    program[_getReference(modes[0], program[instructionPointer + 1])] = input.removeFirst();
    return program[instructionPointer + 1] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Write extends Instruction {
  Write(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 1;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    List<int> modes = _getModes(program[instructionPointer], numParams);
    final out = _getParam(program, modes[0], program[instructionPointer + 1]);
    print("Machine write: $out");
    machine.addOutput(out);
    return instructionPointer + numParams + 1;
  }
}

class JumpIfTrue extends Instruction {
  JumpIfTrue(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 2;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    final modes = _getModes(program[instructionPointer], numParams);
    if (_getParam(program, modes[0], program[instructionPointer + 1]) != 0) {
      return _getParam(program, modes[1], program[instructionPointer + 2]);
    } else
      return instructionPointer + numParams + 1;
  }
}

class JumpIfFalse extends Instruction {
  JumpIfFalse(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 2;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    final modes = _getModes(program[instructionPointer], numParams);
    if (_getParam(program, modes[0], program[instructionPointer + 1]) == 0) {
      return _getParam(program, modes[1], program[instructionPointer + 2]);
    } else
      return instructionPointer + numParams + 1;
  }
}

class LessThan extends Instruction {
  LessThan(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 3;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    final modes = _getModes(program[instructionPointer], numParams);
    bool lessThan =
        _getParam(program, modes[0], program[instructionPointer + 1]) <
            _getParam(program, modes[1], program[instructionPointer + 2]);
    program[_getReference(modes[2], program[instructionPointer + 3])] = lessThan ? 1 : 0;
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Equals extends Instruction {
  Equals(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 3;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    final modes = _getModes(program[instructionPointer], numParams);
    bool equals =
        _getParam(program, modes[0], program[instructionPointer + 1]) ==
            _getParam(program, modes[1], program[instructionPointer + 2]);
    program[_getReference(modes[2], program[instructionPointer + 3])] = equals ? 1 : 0;
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class RelativeBaseOffset extends Instruction {
  RelativeBaseOffset(IntCodeMachine machine) : super(machine);

  @override
  int get numParams => 1;

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    final modes = _getModes(program[instructionPointer], numParams);
    machine.relativeOffset +=
        _getParam(program, modes[0], program[instructionPointer + 1]);
    return instructionPointer + numParams + 1;
  }
}

class Halt extends Instruction {
  Halt(IntCodeMachine machine) : super(machine);

  @override
  Future<int> run(List<int> program, int instructionPointer) async {
    return -1;
  }
}

class IntCodeException implements Exception {
  final String message;

  IntCodeException(this.message);
}
