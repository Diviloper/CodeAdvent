import '../common.dart';

void main() {
  first();
  second();
}

void first() {
  final memory = readListInt('src/Day 6/input.txt', separator: '\t');
  List<int> current = memory;
  final visited = <List<int>>[];
  int steps = 0;
  while (!contains(visited, current)) {
    visited.add(List.from(current));
    redistribute(current);
    steps++;
  }
  print(steps);
}

void second() {
  final memory = readListInt('src/Day 6/input.txt', separator: '\t');
  List<int> current = memory;
  final visited = <List<int>>[];
  while (!contains(visited, current)) {
    visited.add(List.from(current));
    redistribute(current);
  }
  print(visited.length - visited.indexWhere(current.equals));
}

void redistribute(List<int> list) {
  final index = indexOfMax(list);
  final blocks = list[index];
  list[index] = 0;
  for (int i = 1; i <= blocks; ++i) {
    list[(index + i) % list.length]++;
  }
}

int indexOfMax(List<int> list) {
  int index = 0;
  int maximum = list.first;
  for (int i = 1; i < list.length; ++i) {
    if (list[i] > maximum) {
      index = i;
      maximum = list[i];
    }
  }
  return index;
}

bool contains(List<List<int>> container, List<int> element) {
  for (final list in container) {
    if (element.equals(list)) return true;
  }
  return false;
}
