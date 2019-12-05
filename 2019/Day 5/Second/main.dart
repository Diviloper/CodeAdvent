import 'dart:io';
import '../../Common/IntCodeComputer/intCodeComputer.dart';

void main() {
  final file = File('input.txt');
  final program = file.readAsStringSync().split(',').map((v) => int.parse(v)).toList();
  final int output = IntCodeMachine.instance.runProgram(program);
  print("Output: $output");
}