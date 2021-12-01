import 'dart:io';
import '../common.dart';

void main() {
  final regex = RegExp(r'^position=<(\-?\d+),(\-?\d+)>velocity=<(\-?\d+),(\-?\d+)>$');
  final lines = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.replaceAll(' ', ''))
      .map(regex.firstMatch)
      .whereType<RegExpMatch>()
      .map((e) => Tuple(Point(int.parse(e[1]!), int.parse(e[2]!)), Vector(int.parse(e[3]!), int.parse(e[4]!))))
      .toList();
  final positions = lines.map((e) => e.first).toList();
  final velocities = lines.map((e) => e.second).toList();
  Box boundingBox = positions.getBoundingBox();
  int previousSize = boundingBox.area;
  int currentSize = previousSize;
  int i=0;
  do {
    previousSize = currentSize;
    for (int i = 0; i < positions.length; i++) positions[i] = positions[i] + velocities[i];
    boundingBox = positions.getBoundingBox();
    currentSize = boundingBox.area;
    ++i;
  } while (currentSize < previousSize);
  for (int i = 0; i < positions.length; i++) positions[i] = positions[i] + (velocities[i] * -1);
  printPoints(positions);
  print(i-1);
}

void printPoints(List<Point> positions) {
  Box boundingBox = positions.getBoundingBox();
  final xLength = boundingBox.topRight.x - boundingBox.bottomLeft.x + 1;
  for (int y = boundingBox.bottomLeft.y; y <= boundingBox.topRight.y; ++y) {
    final line = Iterable.generate(xLength, (x) => Point(boundingBox.bottomLeft.x + x, y))
        .map(positions.contains)
        .map((e) => e ? '#' : '.')
        .join();
    print(line);
  }
}
