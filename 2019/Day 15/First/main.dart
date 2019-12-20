import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

import '../../Common/IntCodeComputer/intCodeComputer.dart';

void main() async {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();

  final map = await exploreMap(program);
  Map<int, String> converter = {-1: ' ', 0: '#', 1: '.', 2: 'X', 3: '^', 4: 'O'};
  map[40][40] = 4;
  int pathLength = minSteps(map);
  for (var row in map) print(row.map((val) => converter[val]).join());
  print(pathLength);
}

Future<List<List<int>>> exploreMap(List<int> program) async {
  final machine = IntCodeMachine();
  StreamController<int> controller = StreamController();
  machine.streamInput = controller.stream;
  machine.runProgram(program);
  List<List<int>> map = List.generate(100, (i) => List.filled(100, -1));
  int currentX = 40, currentY = 40;
  map[currentX][currentY] = 1;
  int dir = 1;
  controller.add(dir);
  Set<String> visited = {"$currentX:$currentY"};
  Queue<int> path = Queue.from([dir]);
  await for (var report in machine.output.stream) {
    if (report == 0) {
      int wallX = currentX, wallY = currentY;
      switch (dir) {
        case 1:
          ++wallX;
          break;
        case 2:
          --wallX;
          break;
        case 3:
          --wallY;
          break;
        case 4:
          ++wallY;
          break;
      }
      path.removeLast();
      map[wallX][wallY] = 0;
      visited.add("$wallX:$wallY");
    } else if (report == 1 || report == 2) {
      switch (dir) {
        case 1:
          ++currentX;
          break;
        case 2:
          --currentX;
          break;
        case 3:
          --currentY;
          break;
        case 4:
          ++currentY;
          break;
      }
      map[currentX][currentY] = report;
      visited.add("$currentX:$currentY");
    }
    if (!visited.contains("${currentX + 1}:$currentY")) {
      dir = 1;
      path.addLast(dir);
    } else if (!visited.contains("${currentX - 1}:$currentY")) {
      dir = 2;
      path.addLast(dir);
    } else if (!visited.contains("$currentX:${currentY - 1}")) {
      dir = 3;
      path.addLast(dir);
    } else if (!visited.contains("$currentX:${currentY + 1}")) {
      dir = 4;
      path.addLast(dir);
    } else {
      if (path.isEmpty) break;
      switch (path.removeLast()) {
        case 1:
          dir = 2;
          break;
        case 2:
          dir = 1;
          break;
        case 3:
          dir = 4;
          break;
        case 4:
          dir = 3;
          break;
      }
    }
    controller.add(dir);
  }
  return map;
}

int minSteps(List<List<int>> map) {
  Set<String> unvisitedNodes = {}, visitedNodes = {};
  PriorityQueue<MapEntry<String, int>> toVisit =
      PriorityQueue((e1, e2) => e1.value.compareTo(e2.value));
  Map<String, int> distances = {};
  Map<String, String> predecessor = {};
  for (int i = 0; i < map.length; ++i) {
    for (int j = 0; j < map[i].length; ++j) {
      unvisitedNodes.add("$i:$j");
      distances["$i:$j"] = -1;
    }
  }
  distances["40:40"] = 0;
  int currentX = 40, currentY = 40;
  String currentNode = "$currentX:$currentY";
  while (map[currentX][currentY] != 2) {
    int currentDistance = distances[currentNode];
    if (map[currentX + 1][currentY] != 0) {
      final node = "${currentX + 1}:$currentY";
      if (distances[node] < 0 || distances[node] > currentDistance + 1) {
        distances[node] = currentDistance + 1;
        predecessor[node] = currentNode;
        toVisit.add(MapEntry(node, distances[node]));
      }
    }
    if (map[currentX - 1][currentY] != 0) {
      final node = "${currentX - 1}:$currentY";
      if (distances[node] < 0 || distances[node] > currentDistance + 1) {
        distances[node] = currentDistance + 1;
        predecessor[node] = currentNode;
        toVisit.add(MapEntry(node, distances[node]));
      }
    }
    if (map[currentX][currentY + 1] != 0) {
      final node = "$currentX:${currentY + 1}";
      if (distances[node] < 0 || distances[node] > currentDistance + 1) {
        distances[node] = currentDistance + 1;
        predecessor[node] = currentNode;
        toVisit.add(MapEntry(node, distances[node]));
      }
    }
    if (map[currentX][currentY - 1] != 0) {
      final node = "$currentX:${currentY - 1}";
      if (distances[node] < 0 || distances[node] > currentDistance + 1) {
        distances[node] = currentDistance + 1;
        predecessor[node] = currentNode;
        toVisit.add(MapEntry(node, distances[node]));
      }
    }
    unvisitedNodes.remove(currentNode);
    visitedNodes.add(currentNode);
    currentNode = toVisit.removeFirst().key;
    final coords = currentNode.split(':');
    currentX = int.parse(coords[0]);
    currentY = int.parse(coords[1]);
  }
  int count = 0;
  while (predecessor[currentNode] != "40:40") {
    final coords = currentNode.split(':');
    currentX = int.parse(coords[0]);
    currentY = int.parse(coords[1]);
    map[currentX][currentY] = 3;
    currentNode = predecessor[currentNode];
    ++count;
  }
  return ++count;
}
