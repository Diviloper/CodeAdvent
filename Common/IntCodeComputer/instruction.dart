import 'dart:io';

abstract class Instruction {
  int run(List<int> program, int instructionPointer);

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
      default:
        throw IntCodeException("Incorrect param mode");
    }
  }
}

class Addition extends Instruction {
  @override
  int get numParams => 3;
  @override
  int run(List<int> program, int instructionPointer) {
    List<int> modes = _getModes(program[instructionPointer], numParams);
    program[program[instructionPointer + 3]] =
        _getParam(program, modes[0], program[instructionPointer + 1]) +
            _getParam(program, modes[1], program[instructionPointer + 2]);
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Multiplication extends Instruction {
  @override
  int get numParams => 3;
  @override
  int run(List<int> program, int instructionPointer) {
    List<int> modes = _getModes(program[instructionPointer], numParams);
    program[program[instructionPointer + 3]] =
        _getParam(program, modes[0], program[instructionPointer + 1]) *
            _getParam(program, modes[1], program[instructionPointer + 2]);
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Read extends Instruction {
  @override
  int get numParams => 1;

  @override
  int run(List<int> program, int instructionPointer) {
    print("Enter value: ");
    int input = int.tryParse(stdin.readLineSync());
    while (input == null) {
      print("Value invalid. Try again: ");
      input = int.tryParse(stdin.readLineSync());
    }
    program[program[instructionPointer + 1]] = input;
    return program[instructionPointer + 1] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Write extends Instruction {
  @override
  int get numParams => 1;

  @override
  int run(List<int> program, int instructionPointer) {
    List<int> modes = _getModes(program[instructionPointer], numParams);
    print(
        "Machine write: ${_getParam(program, modes[0], program[instructionPointer + 1])}");
    return instructionPointer + numParams + 1;
  }
}

class JumpIfTrue extends Instruction {
  @override
  int get numParams => 2;

  @override
  int run(List<int> program, int instructionPointer) {
    final modes = _getModes(program[instructionPointer], numParams);
    if (_getParam(program, modes[0], program[instructionPointer + 1]) != 0) {
      return _getParam(program, modes[1], program[instructionPointer + 2]);
    } else
      return instructionPointer + numParams + 1;
  }
}

class JumpIfFalse extends Instruction {
  @override
  int get numParams => 2;

  @override
  int run(List<int> program, int instructionPointer) {
    final modes = _getModes(program[instructionPointer], numParams);
    if (_getParam(program, modes[0], program[instructionPointer + 1]) == 0) {
      return _getParam(program, modes[1], program[instructionPointer + 2]);
    } else
      return instructionPointer + numParams + 1;
  }
}

class LessThan extends Instruction {
  @override
  int get numParams => 3;

  @override
  int run(List<int> program, int instructionPointer) {
    final modes = _getModes(program[instructionPointer], numParams);
    bool lessThan =
        _getParam(program, modes[0], program[instructionPointer + 1]) <
            _getParam(program, modes[1], program[instructionPointer + 2]);
    program[program[instructionPointer + 3]] = lessThan ? 1 : 0;
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Equals extends Instruction {
  @override
  int get numParams => 3;

  @override
  int run(List<int> program, int instructionPointer) {
    final modes = _getModes(program[instructionPointer], numParams);
    bool equals =
        _getParam(program, modes[0], program[instructionPointer + 1]) ==
            _getParam(program, modes[1], program[instructionPointer + 2]);
    program[program[instructionPointer + 3]] = equals ? 1 : 0;
    return program[instructionPointer + 3] == instructionPointer
        ? instructionPointer
        : instructionPointer + numParams + 1;
  }
}

class Halt extends Instruction {
  @override
  int run(List<int> program, int instructionPointer) {
    return -1;
  }
}

class IntCodeException implements Exception {
  final String message;
  IntCodeException(this.message);
}
