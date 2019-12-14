import 'dart:io';

import 'package:trotter/trotter.dart';

import '../../Common/IntCodeComputer/intCodeComputer.dart';

void main() async {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();
  final perms = Permutations(5, [5, 6, 7, 8, 9]);
  int max_output = 0;
  List<int> max_output_sequence = [];
  for (List<int> perm in perms()) {
    List<IntCodeMachine> machines = initMachines(perm);
    await Future.wait(
        machines.map((machine) => machine.runProgram(List.from(program))));
    if (machines.last.lastOutput > max_output) {
      max_output = machines.last.lastOutput;
      max_output_sequence = perm;
    }
  }
  print(
      "Max output value $max_output achieved with sequence ${max_output_sequence.join('-')}");
}

List<IntCodeMachine> initMachines(List<int> codes) {
  final numMachines = codes.length;
  final machines =
      List.generate(numMachines, (i) => IntCodeMachine(machineCode: i));
  for (int i = 0; i < numMachines; ++i) {
    IntCodeMachine.connect(machines[i], machines[(i + 1) % numMachines]);
    machines[i].output.add(codes[(i + 1) % numMachines]);
  }
  machines.last.output.add(0);
  return machines;
}
