import 'dart:collection';
import 'dart:io';

void main() {
  first();
  second();
}

void first() {
  final programs = File('src/Day 12/input.txt').readAsLinesSync();
  final group = getGroup(programs, 0);
  print(group.length);
}

Set<int> getGroup(List<String> programs, int root) {
  Set<int> visited = {};
  Queue<int> toVisit = Queue()..add(root);
  while (toVisit.isNotEmpty) {
    final current = toVisit.removeFirst();
    if (visited.contains(current)) continue;
    visited.add(current);
    toVisit
        .addAll(programs[current].split('> ').last.split(', ').map(int.parse));
  }
  return visited;

}

void second() {
  final programs = File('src/Day 12/input.txt').readAsLinesSync();
  final unvisited = programs.map((e) => int.parse(e.split(' ').first)).toSet();
  int groups = 0;
  while (unvisited.isNotEmpty) {
    final group = getGroup(programs, unvisited.first);
    unvisited.removeAll(group);
    ++groups;
  }
  print(groups);
}
