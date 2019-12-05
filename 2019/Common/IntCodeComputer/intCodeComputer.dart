import 'instruction.dart';

class IntCodeMachine {
  static IntCodeMachine _machine;

  final Map<int, Instruction> _instructions = {
    1: Addition(),
    2: Multiplication(),
    3: Read(),
    4: Write(),
    5: JumpIfTrue(),
    6: JumpIfFalse(),
    7: LessThan(),
    8: Equals(),
    99: Halt(),
  };

  IntCodeMachine._();

  static IntCodeMachine get instance {
    _machine ??= IntCodeMachine._();
    return _machine;
  }

  int runProgram(List<int> program) {
    int instructionPointer = 0;
    while (instructionPointer != -1) {
      int operation = program[instructionPointer];
      instructionPointer =
          _instructions[operation % 100].run(program, instructionPointer);
    }
    return program[0];
  }
}
