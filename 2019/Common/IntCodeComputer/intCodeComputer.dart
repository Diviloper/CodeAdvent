import 'dart:async';
import 'dart:collection';

import 'instruction.dart';

class IntCodeMachine {
  Queue<int> _outputs = Queue();
  StreamController<int> output = StreamController();
  int machineCode;

  final Map<int, Instruction> _instructions = {
    1: Addition(),
    2: Multiplication(),
    3: Read(),
    5: JumpIfTrue(),
    6: JumpIfFalse(),
    7: LessThan(),
    8: Equals(),
    99: Halt(),
  };

  IntCodeMachine({this.machineCode}) {
    _instructions[4] = Write(_addOutput);
  }

  void set readInput(Queue<int> input) => _instructions[3] = ReadInput(input);

  void set streamInput(Stream<int> input) =>
      _instructions[3] = ReadStream(input);

  void setStdInput() => _instructions[3] = Read();

  int get lastOutput => _outputs.first;

  int popOutput() => _outputs.removeFirst();

  void clearOutputs() => _outputs.clear();

  void _addOutput(int output) {
    _outputs.addFirst(output);
    this.output.add(output);
  }

  Future<int> runProgram(List<int> program) async {
    int instructionPointer = 0;
    while (instructionPointer != -1) {
      int operation = program[instructionPointer];
      instructionPointer =
          await _instructions[operation % 100].run(program, instructionPointer);
    }
    output.close();
    return program[0];
  }

  static void connect(IntCodeMachine from, IntCodeMachine to) {
    to.streamInput = from.output.stream;
  }
}
