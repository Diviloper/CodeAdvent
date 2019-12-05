import 'dart:io';

void main() {
  final file = new File('./input.txt');
  String input = file.readAsStringSync();
  List<int> program = input.split(',').map((v) => int.parse(v)).toList();
  program[1] = 12;
  program[2] = 2;
  executeIntCode(program);
}

void executeIntCode(List<int> program) {
  int current = 0;
  while (program[current] != 99) {
    int code = program[current];
    switch (code) {
      case 1:
        program[program[current + 3]] = program[program[current + 1]] + program[program[current + 2]];
        break;
      case 2:
        program[program[current + 3]] = program[program[current + 1]] * program[program[current + 2]];
        break;
      default:
        print("Something went wrong!!");
        return;
    }
    current += 4;
  }
  print(program.join(','));
}