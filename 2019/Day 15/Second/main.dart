import 'dart:async';
import 'dart:collection';
import 'dart:io';

import '../../Common/IntCodeComputer/intCodeComputer.dart';

void main() async {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();

  final map = await exploreMap(program);
  int minutes = minutesToFill(map);
  print(minutes);
}

Future<List<List<int>>> exploreMap(List<int> program) async {
  final machine = IntCodeMachine();
  StreamController<int> controller = StreamController();
  machine.streamInput = controller.stream;
  machine.runProgram(program);
  List<List<int>> map = List.generate(50, (i) => List.filled(80, -1));
  int currentX = 25, currentY = 30;
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

int minutesToFill(List<List<int>> map) {
  int mins;
  Map<int, String> converter = {
    -1: ' ',
    0: '#',
    1: '.',
    2: 'O',
  };
  for (mins = 0; thereAreCellsWithoutOxygen(map); ++mins) {
    for (int i = 0; i < map.length; ++i) {
      for (int j = 0; j < map[i].length; ++j) {
        if (map[i][j] == 1 &&
            (map[i + 1][j] == 2 ||
                map[i - 1][j] == 2 ||
                map[i][j + 1] == 2 ||
                map[i][j - 1] == 2))
          map[i][j] = 3;
      }
    }
    for (var row in map) for (int i=0; i<row.length; ++i) if (row[i] == 3) row[i] = 2;
    for (var row in map) print(row.map((v) => converter[v]).join());
  }
  return mins;
}

bool thereAreCellsWithoutOxygen(List<List<int>> map) {
  for (var row in map) {
    for (var cell in row) {
      if (cell == 1) return true;
    }
  }
  return false;
}
