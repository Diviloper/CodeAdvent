import 'intCodeComputer.dart';

void main() async {
  final input = "1002,4,3,4,33";
  final program = input.split(',').map((v) => int.parse(v)).toList();
  print("Output: ${await IntCodeMachine().runProgram(program)}");
  print("Program:\n ${program.join(',')}");
}