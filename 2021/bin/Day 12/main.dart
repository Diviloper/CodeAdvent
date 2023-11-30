import 'dart:io';

void main() {
  final caves = CaveSystem.fromStrings(File('./input.txt').readAsLinesSync());
  final paths = caves.getPaths();
  final paths2 = caves.getPathsWithDoubleVisit();
  print(paths.length);
  print(paths2.length);
}

class CaveSystem {
  final Map<String, List<String>> connections = {};

  CaveSystem.fromStrings(List<String> sources) {
    for (final connection in sources) {
      final ends = connection.split('-');
      connections.update(
        ends.first,
        (value) => value..add(ends.last),
        ifAbsent: () => [ends.last],
      );
      connections.update(
        ends.last,
        (value) => value..add(ends.first),
        ifAbsent: () => [ends.first],
      );
    }
  }

  bool _canRevisit(String cave) => cave.toUpperCase() == cave;

  List<String> getPaths() {
    final paths = <String>[];
    getPathFromCave('start', paths, ['start'], false);
    return paths;
  }

  void getPathFromCave(
    String currentCave,
    List<String> finishedPaths,
    List<String> currentPath,
    bool doubleVisit,
  ) {
    if (currentCave == 'end') {
      finishedPaths.add(currentPath.join(','));
      return;
    }
    for (final nextCave in connections[currentCave] ?? []) {
      bool newDoubleVisit = doubleVisit;
      if (currentPath.contains(nextCave)) {
        if (!_canRevisit(nextCave)) {
          if (doubleVisit && nextCave != 'start') {
            newDoubleVisit = false;
          } else {
            continue;
          }
        }
      }
      currentPath.add(nextCave);
      getPathFromCave(nextCave, finishedPaths, currentPath, newDoubleVisit);
      currentPath.removeLast();
    }
  }

  List<String> getPathsWithDoubleVisit() {
    final paths = <String>[];
    getPathFromCave('start', paths, ['start'], true);
    return paths;
  }
}
