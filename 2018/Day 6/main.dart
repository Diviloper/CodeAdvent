import 'dart:io';
import '../common.dart';

void main() {
  final points = File('input.txt')
      .readAsLinesSync()
      .map((e) => e.split(', '))
      .map((e) => Point(int.parse(e[0]), int.parse(e[1])))
      .toList();

  findLargestSafeArea(points);
  findLargestIncludingArea(points);
}

void findLargestIncludingArea(List<Point> points) {
  final boundingBox = points.getBoundingBox();
  int areaSize = 0;
  for (int x = boundingBox.bottomLeft.x; x <= boundingBox.topRight.x; ++x) {
    for (int y = boundingBox.bottomLeft.y; y <= boundingBox.topRight.y; ++y) {
      final currentPoint = Point(x, y);
      final sumOfDistances = points.map((point) => point.manhattanDistance(currentPoint)).reduce((a, b) => a + b);
      if (sumOfDistances < 10000) {
        areaSize++;
      }
    }
  }
  print(areaSize);
}

void findLargestSafeArea(List<Point> points) {
  final boundingBox = points.getBoundingBox();
  final areaSizes = List.filled(points.length, 0);
  for (int x = boundingBox.bottomLeft.x; x <= boundingBox.topRight.x; ++x) {
    for (int y = boundingBox.bottomLeft.y; y <= boundingBox.topRight.y; ++y) {
      final currentPoint = Point(x, y);
      int closestPoint = -1;
      int minDistance = boundingBox.bottomLeft.manhattanDistance(boundingBox.topRight);
      bool tie = false;
      for (int i = 0; i < points.length; i++) {
        final point = points[i];
        final currentDistance = currentPoint.manhattanDistance(point);
        if (currentDistance < minDistance) {
          minDistance = currentDistance;
          closestPoint = i;
          tie = false;
        } else if (currentDistance == minDistance) {
          tie = true;
        }
      }
      if (!tie) {
        if (x == boundingBox.bottomLeft.x ||
            x == boundingBox.topRight.x ||
            y == boundingBox.bottomLeft.y ||
            y == boundingBox.topRight.y)
          areaSizes[closestPoint] = -1;
        else if (areaSizes[closestPoint] != -1) areaSizes[closestPoint]++;
      }
    }
  }
  final largestArea = areaSizes.getIndexOfLargestValue();
  print(largestArea.second);
}
