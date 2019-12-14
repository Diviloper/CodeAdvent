import 'dart:collection';
import 'dart:io';

import 'package:trotter/trotter.dart';

import '../../Common/IntCodeComputer/intCodeComputer.dart';

void main() async {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();
  final perms = Permutations(5, [0, 1, 2, 3, 4]);
  int max_output = 0;
  List<int> max_output_sequence;
  for (List<int> per in perms()) {
    int output = 0;
    for (int code in per) {
      IntCodeMachine machine = IntCodeMachine()
        ..machineCode = 0
        ..readInput = Queue.from([code, output]);
      await machine.runProgram(program);
      output = machine.popOutput();
    }
    if (output > max_output) {
      max_output = output;
      max_output_sequence = per;
    }
  }
  print(
      "Max output value $max_output achieved with sequence ${max_output_sequence.join('-')}");
}
