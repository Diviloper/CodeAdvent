import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

typedef Graph = Map<String, Set<String>>;

void main() {
  final edges = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split('-'))
      .map((l) => (l.first, l.last))
      .toList();
  final graph = buildGraph(edges);

  final first = getCliques(graph, 3)
      .where((clique) => clique.any((node) => node.startsWith("t")))
      .length;
  print(first);

  int size = 4;
  while (true) {
    final cliques = getCliques(graph, size).toList();
    if (cliques.length <= 1) {
      print(cliques.single.join(','));
      break;
    }
    print("${cliques.length} of size $size");
    size++;
  }
}

Graph buildGraph(List<(String, String)> edges) {
  final adjacencyMap = <String, Set<String>>{};
  for (final (from, to) in edges) {
    adjacencyMap[from] = (adjacencyMap[from] ?? {})..add(to);
    adjacencyMap[to] = (adjacencyMap[to] ?? {})..add(from);
  }
  return adjacencyMap;
}

Map<int, Set<String>> memory = {};

Set<List<String>> getCliques(Graph graph, int size) {
  var cliques = graph.keys.toSet();
  for (int i = 0; i < size; ++i) {
    final newCliques = <String>{};
    for (final current in cliques.map((c) => c.split(','))) {
      final candidates = current.map((n) => graph[n]!).intersection;
      for (final candidate in candidates) {
        current.add(candidate);
        newCliques.add(current.sorted((a, b) => a.compareTo(b)).join(','));
        current.remove(candidate);
      }
    }
    cliques = newCliques;
  }
  return cliques.map((clique) => clique.split(',')).toSet();
}
