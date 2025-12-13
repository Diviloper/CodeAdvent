import 'dart:io';
import 'package:collection/collection.dart';

import '../directions.dart';
import '../matrix.dart';

class Present {
  final List<List<String>> shape;

  Present(this.shape);

  Iterable<Position> get positions sync* {
    for (int i = 0; i < shape.length; ++i) {
      final line = shape[i];
      for (int j = 0; j < line.length; ++j) {
        if (line[j] == "#") yield Position((i, j));
      }
    }
  }

  List<Present> equivalents() {
    final presents = <Present>{
      this,
      Present(shape.rotate()),
      Present(shape.rotate().rotate()),
      Present(shape.rotate().rotate().rotate()),
      Present(shape.flipHorizontal()),
      Present(shape.flipVertical()),
      Present(shape.flipMainDiagonal()),
      Present(shape.flipAntiDiagonal()),
    };

    return presents.toList();
  }

  @override
  bool operator ==(Object other) {
    if (other is! Present) return false;
    for (int i = 0; i < shape.length; ++i) {
      final line = shape[i];
      final otherLine = other.shape[i];
      for (int j = 0; j < line.length; ++j) {
        if (line[j] != otherLine[j]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => shape.map((row) => row.join()).join().hashCode;
}

class Region {
  final (int, int) size;
  final List<int> presents;

  Set<Position> occupiedPositions = {};

  Region(this.size, this.presents);

  bool fitsAt(Present present, Position at) =>
      !present.positions.map((p) => p + at).any(occupiedPositions.contains);

  void insertAt(Present present, Position at) =>
      occupiedPositions.addAll(present.positions.map((p) => p + at));

  void removeAt(Present present, Position at) =>
      occupiedPositions.removeAll(present.positions.map((p) => p + at));

  int get remainingPositions => size.$1 * size.$2 - occupiedPositions.length;

  @override
  String toString() => "${size.$1}x${size.$2}: ${presents.join(" ")}";
}

void main() {
  final input = File('./input.txt').readAsStringSync();

  final (presents, regions) = parseInput(input);

  first(presents, regions);
}

(List<Present>, List<Region>) parseInput(String input) {
  final [...presentInputs, regionInput] = input.split(
    "${Platform.lineTerminator}${Platform.lineTerminator}",
  );
  final regions = regionInput
      .split(Platform.lineTerminator)
      .map((line) => line.split(": "))
      .map(
        (parts) => (
          parts.first.split("x").map(int.parse).toList(),
          parts.last.split(" ").map(int.parse).toList(),
        ),
      )
      .map((parts) => Region((parts.$1.first, parts.$1.last), parts.$2))
      .toList();

  final presents = presentInputs.map(parsePresent).toList();
  return (presents, regions);
}

Present parsePresent(String presentInput) {
  final lines = presentInput
      .split(Platform.lineTerminator)
      .sublist(1)
      .map((line) => line.split(''))
      .toList();
  return Present(lines);
}

void first(List<Present> presents, List<Region> regions) {
  int fits = 0;
  for (final region in regions) {
    stdout.write("Checking region $region: ");
    if (fitsPresents(region, presents)) {
      fits += 1;
      print("It fits!!");
    } else {
      print("It doesn't fit :(");
    }
  }
  print(fits);
}

bool fitsPresents(Region region, List<Present> presents) =>
    fitsPresentsAt(region, presents, Position((0, 0)));

bool fitsPresentsAt(Region region, List<Present> presents, Position at) {
  if (region.remainingPositions < requiredPositions(region, presents)) {
    return false;
  }
  if (at.j > region.size.$2 - 3) {
    return fitsPresentsAt(region, presents, Position((at.i + 1, 0)));
  }
  if (at.i > region.size.$1 - 3) {
    return region.presents.every((p) => p == 0);
  }
  final nextPos = Position((at.i, at.j + 1));
  for (int i = 0; i < presents.length; ++i) {
    if (region.presents[i] == 0) continue;
    for (final alternative in presents[i].equivalents()) {
      if (region.fitsAt(alternative, at)) {
        region.insertAt(alternative, at);
        region.presents[i]--;
        if (fitsPresentsAt(region, presents, nextPos)) return true;
        region.presents[i]++;
        region.removeAt(alternative, at);
      }
    }
  }
  return fitsPresentsAt(region, presents, nextPos);
}

int requiredPositions(Region region, List<Present> presents) {
  return region.presents
      .mapIndexed((i, p) => p * presents[i].positions.length)
      .sum;
}
