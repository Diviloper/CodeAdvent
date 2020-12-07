import 'dart:collection';
import 'dart:io';

void main() {
  final entries = File('./input.txt').readAsLinesSync();
  first(entries);
  second(entries);
}

void first(List<String> entries) {
  final containerRegexp = RegExp(r'^(\w+ \w+) bags contain ');
  final containedRegexp = RegExp(r'(?:\d+ (\w+ \w+) bags?)');
  final containedBy = <String, Set<String>>{};
  for (final entry in entries) {
    final color = containerRegexp.firstMatch(entry)[1];
    for (final match in containedRegexp.allMatches(entry)) {
      containedBy.update(match[1], (value) => value..add(color),
          ifAbsent: () => {color});
    }
  }
  final visited = <String>{};
  final next = Queue<String>.of(['shiny gold']);
  while (next.isNotEmpty) {
    final current = next.removeFirst();
    if (visited.contains(current)) continue;
    next.addAll(containedBy[current] ?? []);
    visited.add(current);
  }
  print(visited.length - 1);
}

void second(List<String> entries) {
  final containerRegexp = RegExp(r'^(\w+ \w+) bags contain ');
  final containedRegexp = RegExp(r'(?:(\d+) (\w+ \w+) bags?)');
  final contains = <String, List<String>>{
    for (final entry in entries)
      containerRegexp.firstMatch(entry)[1]: [
        for (final match in containedRegexp.allMatches(entry))
          for (int i=0; i < int.parse(match[1]); ++i)
            match[2]
      ]
  };
  final count = containedBags('shiny gold', contains, {});
  print(count);
}

int containedBags(String bag, Map<String, List<String>> contents, Map<String, int> memory) {
  if (!memory.containsKey(bag)) {
    int count = 0;
    for (final subBag in contents[bag]) {
      count += containedBags(subBag, contents, memory) + 1;
    }
    memory[bag] = count;
  }
  return memory[bag];
}