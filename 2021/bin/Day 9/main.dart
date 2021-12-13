import 'dart:collection';
import 'dart:io';

import '../common.dart';

void main() {
  final heights = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map(int.parse).toList())
      .toList();
  getLowerPointsRisk(heights);
  getBasinSizes(heights);
}

void getBasinSizes(List<List<int>> heights) {
  final lowerPoints = getLowerPoints(heights);
  final basins = lowerPoints.keys
      .map((e) => getBasin(e, heights).length)
      .toList()
    ..sort((a, b) => b.compareTo(a));
  print(basins.take(3).reduce((value, element) => value * element));
}

void getLowerPointsRisk(List<List<int>> heights) {
  final lowerPoints = getLowerPoints(heights);
  print(lowerPoints.values
      .fold<int>(0, (previousValue, element) => previousValue + element + 1));
}

Set<Tuple<int, int>> getBasin(
  Tuple<int, int> lowerPoint,
  List<List<int>> heights,
) {
  final basin = <Tuple<int, int>>{};
  final next = Queue.of([lowerPoint]);
  while (next.isNotEmpty) {
    final current = next.removeFirst();
    if (basin.contains(current)) continue;
    basin.add(current);
    final i = current.first;
    final j = current.second;
    final currentHeight = heights[i][j];
    if (i > 0 && heights[i - 1][j] != 9 && heights[i - 1][j] >= currentHeight) {
      next.addLast(Tuple(i - 1, j));
    }
    if (i < heights.length - 1 &&
        heights[i + 1][j] != 9 &&
        heights[i + 1][j] >= currentHeight) {
      next.addLast(Tuple(i + 1, j));
    }
    if (j > 0 && heights[i][j - 1] != 9 && heights[i][j - 1] >= currentHeight) {
      next.addLast(Tuple(i, j - 1));
    }
    if (j < heights[i].length - 1 &&
        heights[i][j + 1] != 9 &&
        heights[i][j + 1] >= currentHeight) {
      next.addLast(Tuple(i, j + 1));
    }
  }
  return basin;
}

Map<Tuple<int, int>, int> getLowerPoints(List<List<int>> heights) {
  final lowerPoints = <Tuple<int, int>, int>{};
  for (int i = 0; i < heights.length; ++i) {
    for (int j = 0; j < heights[i].length; ++j) {
      final height = heights[i][j];
      if (i > 0 && heights[i - 1][j] <= height) continue;
      if (i < heights.length - 1 && heights[i + 1][j] <= height) continue;
      if (j > 0 && heights[i][j - 1] <= height) continue;
      if (j < heights[i].length - 1 && heights[i][j + 1] <= height) continue;
      lowerPoints[Tuple(i, j)] = height;
    }
  }
  return lowerPoints;
}
