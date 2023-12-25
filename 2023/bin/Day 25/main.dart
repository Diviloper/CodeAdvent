import 'dart:io';
import 'dart:math';

import '../common.dart';

void main() {
  final edges = File('./bin/Day 25/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(': '))
      .map((e) => (e.first, e.last.split(' ')))
      .expand((element) => element.$2.map((e) => (element.$1, e)))
      .toList();

  final graph = buildGraph(edges);
  print(graph.keys.length);

  final random = Random();
  var compacted = compact(graph, random);
  while (compacted.values.first.$1.length > 3) {
    compacted = compact(graph, random);
  }
  print(compacted.values.seconds.prod);
}

Map<String, List<String>> buildGraph(List<(String, String)> edges) {
  final graph = <String, List<String>>{};
  for (final (source, destination) in edges) {
    graph.update(
      source,
      (value) => value..add(destination),
      ifAbsent: () => [destination],
    );
    graph.update(
      destination,
      (value) => value..add(source),
      ifAbsent: () => [source],
    );
  }
  return graph;
}

Map<String, (List<String>, int)> compact(
    Map<String, List<String>> graph, Random random) {
  final compacted = {
    for (final (node, edges) in graph.records) node: edges.copy()
  };
  final counters = {for (final node in graph.keys) node: 1};
  while (compacted.keys.length > 2) {
    final edges = compacted.records
        .expand((element) => element.$2.map((e) => (element.$1, e)))
        .toList();
    final (from, to) = edges[random.nextInt(edges.length)];
    counters.update(from, (value) => value + counters[to]!);
    for (final dest in compacted[to]!) {
      if (dest == from) continue;
      final destEdges = compacted[dest]!;
      destEdges[destEdges.indexOf(to)] = from;
    }
    while (compacted[from]!.remove(to)) {}
    compacted[from]!.addAll(compacted[to]!);
    while (compacted[from]!.remove(from)) {}
    compacted.remove(to);
  }
  return {
    for (final node in compacted.keys) node: (compacted[node]!, counters[node]!)
  };
}
