import 'dart:io';

import '../../Common/IntCodeComputer/intCodeComputer.dart';

void main() {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();
  final machine = IntCodeMachine();
  machine.runProgram(program);
}
