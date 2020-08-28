import '../common.dart';

void main() {
  first();
  second();
}

void first() {
  final list = readListIntLines('src/Day 5/input.txt');
  int steps = 0;
  int current = 0;
  while (current >= 0 && current < list.length) {
    int next = current + list[current];
    list[current]++;
    current = next;
    steps++;
  }
  print(steps);
}

void second() {
  final list = readListIntLines('src/Day 5/input.txt');
  int steps = 0;
  int current = 0;
  while (current >= 0 && current < list.length) {
    int next = current + list[current];
    if (list[current]>= 3) {
      list[current]--;
    } else {
      list[current]++;
    }
    current = next;
    steps++;
  }
  print(steps);}