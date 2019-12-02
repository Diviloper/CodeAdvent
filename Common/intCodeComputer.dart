import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length == 1) {
    final file = new File(arguments[0]);
    String input = file.readAsStringSync();
    List<int> program = input.split(',').map((v) => int.parse(v)).toList();
    executeIntCode(program);
  } else {
    usage();
  }
}

void usage() {
  print("Pass input file as only parameter");
}

void executeIntCode(List<int> program) {
  int current = 0;
  while (program[current] != 99) {
    int code = program[current];
    switch (code) {
      case 1:
        program[program[current + 3]] =
            program[program[current + 1]] + program[program[current + 2]];
        break;
      case 2:
        program[program[current + 3]] =
            program[program[current + 1]] * program[program[current + 2]];
        break;
      default:
        print("Something went wrong!!");
        return;
    }
    current += 4;
  }
  print(program.join(','));
}
