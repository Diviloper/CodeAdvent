import 'dart:io';

class Node {
  List<String> arcs = [];
}

int distance(Map<String, Node> objects, String origin, String destination, Set<String> visited) {
  if (origin == destination) return 0;
  visited.add(origin);
  final originArcs = objects[origin].arcs.where((next) => !visited.contains(next)).toList();
  if (originArcs.isEmpty) return null;
  int dist = objects.length;
  for (var next in originArcs) {
    final d = distance(objects, next, destination, visited);
    if (d != null && d < dist) {
      dist = d + 1;
    }
  }
  return dist;
}

void main() {
  final arcs = File("input.txt").readAsLinesSync();
  Map<String, Node> objects = {};
  for (var arc in arcs) {
    final nodes = arc.split(')');
    objects.update(
      nodes[0],
      (node) => node..arcs.add(nodes[1]),
      ifAbsent: () => Node()..arcs.add(nodes[1]),
    );
    objects.update(
      nodes[1],
      (node) => node..arcs.add(nodes[0]),
      ifAbsent: () => Node()..arcs.add(nodes[0]),
    );
  }
  int dist = distance(objects, "YOU", "SAN", {});
  print(dist - 2);
}
