import 'dart:io';

class Node {
  List<String> entryArcs = [];
  List<String> exitArcs = [];
  int directOrbits = 0;
  int indirectOrbits = 0;
  int get orbits => directOrbits + indirectOrbits;
}

void updateOrbits(Map<String, Node> objects, List<Node> nodes, int indirectOrbits) {
  for (var node in nodes) {
    node.indirectOrbits = indirectOrbits;
    final nodesOrbiting = node.entryArcs.map((orbit) => objects[orbit]).toList();
    updateOrbits(objects, nodesOrbiting, node.orbits);
  }
}

void main() {
  final arcs = File("input.txt").readAsLinesSync();
  Map<String, Node> objects = {};
  for (var arc in arcs) {
    final nodes = arc.split(')');
    objects.update(
      nodes[0],
      (node) => node..entryArcs.add(nodes[1]),
      ifAbsent: () => Node()..entryArcs.add(nodes[1]),
    );
    objects.update(
      nodes[1],
      (node) => node
        ..exitArcs.add(nodes[0])
        ..directOrbits += 1,
      ifAbsent: () => Node()
        ..exitArcs.add(nodes[0])
        ..directOrbits = 1,
    );
  }
  updateOrbits(objects, objects.values.where((node) => node.directOrbits == 0).toList(), 0);
  int orbits = objects.values.map((node) => node.orbits).reduce((curr, next) => curr + next);
  print(orbits);
}
