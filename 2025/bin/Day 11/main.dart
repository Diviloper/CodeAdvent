import 'dart:io';

void main() {
  final input = File('./input.txt').readAsLinesSync();
  final graph = parseGraph(input);
  first(graph);
  second(graph);
}

Map<String, List<String>> parseGraph(List<String> input) {
  final graph = <String, List<String>>{};
  for (final line in input) {
    final [key, values] = line.split(": ");
    graph[key] = values.split(" ");
  }
  return graph;
}

void first(Map<String, List<String>> graph) {
  final next = <String, int>{"you": 1};
  int paths = 0;
  while (next.isNotEmpty) {
    final current = next.keys.first;
    final numPaths = next.remove(current)!;
    if (current == "out") {
      paths += numPaths;
      continue;
    }
    for (final connection in graph[current]!) {
      next.update(connection, (v) => v + numPaths, ifAbsent: () => numPaths);
    }
  }
  print(paths);
}

void second(Map<String, List<String>> graph) {
  final next = <(String, bool, bool), int>{("svr", false, false): 1};
  int paths = 0;
  while (next.isNotEmpty) {
    final (current, dac, fft) = next.keys.first;
    final numPaths = next.remove((current, dac, fft))!;
    if (current == "out") {
      if (dac && fft) paths += numPaths;
      continue;
    }
    for (final connection in graph[current]!) {
      final newDac = dac || connection == "dac";
      final newFft = fft || connection == "fft";
      next.update(
        (connection, newDac, newFft),
        (v) => v + numPaths,
        ifAbsent: () => numPaths,
      );
    }
  }
  print(paths);
}
