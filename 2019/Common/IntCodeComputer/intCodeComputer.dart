import 'dart:async';
import 'dart:collection';

import 'instruction.dart';

class IntCodeMachine {
  Queue<int> _outputs = Queue();
  StreamController<int> output = StreamController();
  int machineCode;
  int relativeOffset = 0;

  final Map<int, Instruction> _instructions = {};

  IntCodeMachine({this.machineCode}) {
    _instructions[1] = Addition(this);
    _instructions[2] = Multiplication(this);
    _instructions[3] = Read(this);
    _instructions[4] = Write(this);
    _instructions[5] = JumpIfTrue(this);
    _instructions[6] = JumpIfFalse(this);
    _instructions[7] = LessThan(this);
    _instructions[8] = Equals(this);
    _instructions[9] = RelativeBaseOffset(this);
    _instructions[99] = Halt(this);
  }

  void set readInput(Queue<int> input) =>
      _instructions[3] = ReadInput(this, input);

  void set streamInput(Stream<int> input) =>
      _instructions[3] = ReadStream(this, input);

  void setStdInput() => _instructions[3] = Read(this);

  int get lastOutput => _outputs.first;

  int popOutput() => _outputs.removeFirst();

  void clearOutputs() => _outputs.clear();

  void addOutput(int output) {
    _outputs.addFirst(output);
    this.output.add(output);
  }

  Future<int> runProgram(List<int> program) async {
    List<int> memory =
        List.from(program)..addAll(List.filled(program.length * 10, 0));
    int instructionPointer = 0;
    while (instructionPointer != -1) {
      int operation = memory[instructionPointer];
      instructionPointer =
          await _instructions[operation % 100].run(memory, instructionPointer);
    }
    output.close();
    return memory[0];
  }

  static void connect(IntCodeMachine from, IntCodeMachine to) {
    to.streamInput = from.output.stream;
  }
}
