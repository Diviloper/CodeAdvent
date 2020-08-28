import 'dart:io';

void main() {
  first();
  second();
}

void first() {
  final lines = File('src/Day 7/input.txt').readAsLinesSync();
  final pattern = RegExp(r'^([a-z]+) \((\d+)\)(?: -> ((?:(?:[a-z]+), )*(?:[a-z]+)))?$');
  final Map<String, String> parents = {};
  final Set<String> programs = {};
  for (final line in lines) {
    final match = pattern.firstMatch(line);
    final parent = match[1];
    programs.add(parent);
    if (match[3] != null) {
      for (final child in match[3].split(', ')) {
        parents[child] = parent;
      }
    }
  }
  print(programs.difference(parents.keys.toSet()));
}

class Program {
  String name;
  int weight;
  List<Program> children = [];

  Program(this.name, this.weight);

  int get towerWeight => weight + children.map((e) => e.towerWeight).fold(0, (value, element) => value + element);
}

void second() {
  final lines = File('src/Day 7/input.txt').readAsLinesSync();
  final pattern = RegExp(r'^([a-z]+) \((\d+)\)(?: -> ((?:(?:[a-z]+), )*(?:[a-z]+)))?$');
  final programs = <String, Program>{};
  final children = <String, List<String>>{};
  for (final line in lines) {
    final match = pattern.firstMatch(line);
    programs[match[1]] = Program(match[1], int.parse(match[2]));
    if (match[3] != null) {
      children[match[1]] = match[3].split(', ').toList();
    } else {
      children[match[1]] = [];
    }
  }
  for (final program in programs.values) {
    program.children = children[program.name].map((e) => programs[e]).toList();
  }

  Program current = programs['vgzejbd'];
  int childIndex = differentValueIndex(current.children.map((e) => e.towerWeight).toList());
  while (childIndex != null) {
    print(current.children.map((e) => e.towerWeight));
    current = current.children[childIndex];
    print('${current.name} -> ${current.weight}');
    childIndex = differentValueIndex(current.children.map((e) => e.towerWeight).toList());
  }
}

int differentValueIndex(List<int> values) {
  int firstValue = values[0];
  int firstIndex = 0;
  int secondValue, secondIndex;
  for (int i = 1; i < values.length; ++i) {
    if (values[i] == firstValue) continue;
    if (values[i] != secondValue) {
      secondValue = values[i];
      secondIndex = i;
    } else {
      return firstIndex;
    }
  }
  return secondIndex;
}
