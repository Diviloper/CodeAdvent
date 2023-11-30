import 'dart:io';

void main() {
  final movements = File('./input.txt').readAsLinesSync().map((e) => e.split(' ')).toList();
  getFinalPosition(movements);
  getFinalPositionAim(movements);
}

void getFinalPositionAim(List<List<String>> movements) {
  int x = 0, depth = 0, aim = 0;
  for (final movement in movements) {
    final direction = movement.first;
    final amount = int.parse(movement.last);
    switch (direction) {
      case 'forward':
        x += amount;
        depth += aim * amount;
        break;
      case 'down':
        aim += amount;
        break;
      case 'up':
        aim -= amount;
        break;
    }
  }
  print(depth * x);

}

void getFinalPosition(List<List<String>> movements) {
  int x = 0, depth = 0;
  for (final movement in movements) {
    final direction = movement.first;
    final amount = int.parse(movement.last);
    switch (direction) {
      case 'forward':
        x += amount;
        break;
      case 'down':
        depth += amount;
        break;
      case 'up':
        depth -= amount;
        break;
    }
  }
  print(depth * x);
}

