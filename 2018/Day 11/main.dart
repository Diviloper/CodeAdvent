import '../common.dart';

void main() {
  final serialNumber = 5468;

  final bestPointSize3 = getBestSquareOfSize(serialNumber, 3);
  print(bestPointSize3);

  final bestPoint = getBestSquare(serialNumber);
  print(bestPoint);
}

Triple<Point, int, int> getBestSquare(int serialNumber) {
  Triple<Point, int, int> bestPoint = Triple(Point(0, 0), 0, 0);
  final grid = List.generate(300, (x) => List.generate(300, (y) => getPowerLevel(x + 1, y + 1, serialNumber)));
  for (int size = 1; size <= 300; size++) {
    final bestPointOfSize = getBestSquareOfSize(serialNumber, size, grid);
    if (bestPointOfSize.second > bestPoint.second) {
      bestPoint = Triple(bestPointOfSize.first, bestPointOfSize.second, size);
    }
  }
  return bestPoint;
}

Tuple<Point, int> getBestSquareOfSize(int serialNumber, int size, [List<List<int>>? grid]) {
  grid ??= List.generate(300, (x) => List.generate(300, (y) => getPowerLevel(x + 1, y + 1, serialNumber)));

  Point bestPoint = Point(0, 0);
  int highestPower = 0;

  for (int x = 0; x <= 300 - size; ++x) {
    int currentPower = Iterable.generate(size * size, (index) => grid![x + index ~/ size][index % size])
        .reduce((value, element) => value + element);
    if (currentPower > highestPower) {
      bestPoint = Point(x + 1, 1);
      highestPower = currentPower;
    }

    for (int y = 1; y <= 300 - size; ++y) {
      for (int subx = x; subx < x + size; ++subx) {
        currentPower -= grid[subx][y - 1];
        currentPower += grid[subx][y + size - 1];
      }

      if (currentPower > highestPower) {
        bestPoint = Point(x + 1, y + 1);
        highestPower = currentPower;
      }
    }
  }
  return Tuple(bestPoint, highestPower);
}

int getPowerLevel(int x, int y, int serialNumber) {
  final rackId = x + 10;
  int powerLevel = rackId * y;
  powerLevel += serialNumber;
  powerLevel *= rackId;
  powerLevel = powerLevel % 1000 ~/ 100;
  return powerLevel - 5;
}
