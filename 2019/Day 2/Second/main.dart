import 'dart:io';

void main(List<String> arguments) {
  final file = new File("./input.txt");
  String input = file.readAsStringSync();
  List<int> program = input.split(',').map((v) => int.parse(v)).toList();
  findVerbAndNoun(program);
}

void findVerbAndNoun(List<int> original) {
  for (var noun = 0; noun < 100; ++noun) {
    for (var verb = 0; verb < 100; ++verb) {
      List<int> program = List.from(original);
      program[1] = noun;
      program[2] = verb;
      if (executeIntCode(program) == 19690720) {
        print("Noun: $noun \nVerb: $verb");
      }
    }
  }
}

int executeIntCode(List<int> program) {
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
        return null;
    }
    current += 4;
  }
  return program[0];
}
