import 'dart:io';

void main() {
  List<String> program = File('./input.txt').readAsLinesSync();
  signalStrength(program, {20, 60, 100, 140, 180, 220});
  show(program);
}

void signalStrength(List<String> program, Set<int> interestingCycles) {
  int cycle = 1;
  int x = 1;
  int sum = 0;
  for (final command in program) {
    if (interestingCycles.contains(cycle)) {
      sum += x * cycle;
    }
    if (command != 'noop') {
      final add = int.parse(command.split(' ').last);
      if (interestingCycles.contains(++cycle)) {
        sum += x * cycle;
      }
      x += add;
    }
    cycle++;
  }
  print(sum);
}

void show(List<String> program) {
  int cycle = 0;
  int x = 1;
  for (final command in program) {
    printPixel(cycle, x);
    if (command != 'noop') {
      final add = int.parse(command.split(' ').last);
      printPixel(++cycle, x);
      x += add;
    }
    cycle++;
  }
}

void printPixel(int cycle, int x) {
  var pixel = cycle % 40;
  if (pixel == 0) {
    print('');
  }
  if ((pixel - x).abs() <= 1) {
    stdout.write('#');
  } else {
    stdout.write(' ');
  }
}
