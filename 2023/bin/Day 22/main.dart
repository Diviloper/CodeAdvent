import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

typedef Position3D = ({int x, int y, int z});

Position3D position3DFromList(List<int> source) =>
    (x: source[0], y: source[1], z: source[2]);

extension on Position3D {
  Position3D drop(int n) => (x: x, y: y, z: z - n);
}

class Brick {
  final int id;
  final List<Position3D> positions;

  final List<Brick> supportedBy = [];
  final List<Brick> supports = [];

  Brick(this.id, this.positions);

  factory Brick.fromString(int id, String source) {
    final [start, end] = source
        .split('~')
        .map((e) => position3DFromList(e.split(',').map(int.parse).toList()))
        .toList();
    final positions = [
      for (int i = start.x; i <= end.x; ++i)
        for (int j = start.y; j <= end.y; ++j)
          for (int k = start.z; k <= end.z; ++k) (x: i, y: j, z: k),
    ];
    return Brick(id, positions);
  }

  Iterable<Position3D> get below =>
      positions.map((e) => (x: e.x, y: e.y, z: e.z - 1));

  void drop([int steps = 1]) {
    for (int i = 0; i < positions.length; ++i) {
      positions[i] = positions[i].drop(steps);
    }
  }

  bool isAt(Position3D position) => positions.contains(position);

  bool atGround() => positions.any((pos) => pos.z == 1);

  @override
  String toString() => 'Brick{id: $id, ${positions.first} -> ${positions.last}';
}

void main() {
  final bricks = File('./bin/Day 22/input.txt')
      .readAsLinesSync()
      .indexed
      .zippedMap(Brick.fromString)
      .toList();

  final stable = <int>{};
  final unstable = Queue<Brick>.from(bricks);

  while (unstable.isNotEmpty) {
    final currentBrick = unstable.removeFirst();
    if (currentBrick.atGround()) {
      stable.add(currentBrick.id);
      continue;
    }
    final lowerBricks = currentBrick.below
        .map((post) => bricks.firstWhereOrNull((b) => b.isAt(post)))
        .whereType<Brick>()
        .where((element) => element != currentBrick)
        .toSet();
    if (lowerBricks.isEmpty) {
      unstable.addFirst(currentBrick..drop());
      continue;
    }
    if (lowerBricks.map((b) => b.id).every(stable.contains)) {
      final lowerStable =
          lowerBricks.where((brick) => stable.contains(brick.id));
      for (final lBrick in lowerStable) {
        lBrick.supports.add(currentBrick);
        currentBrick.supportedBy.add(lBrick);
      }
      stable.add(currentBrick.id);
    } else {
      unstable.addLast(currentBrick);
    }
  }

  print(bricks
      .where((brick) =>
          brick.supports.every((supported) => supported.supportedBy.length > 1))
      .length);
  final memory = <int, Set<int>>{};
  print(bricks.map((e) => getFallingBricks(e, memory)).sum);
}

int getFallingBricks(Brick brick, Map<int, Set<int>> memory) {
  final fallen = <Brick>{brick};
  final nextBricks = Queue<Brick>.of(brick.supports);
  while (nextBricks.isNotEmpty) {
    final currentBrick = nextBricks.removeFirst();
    if (fallen.contains(currentBrick)) continue;
    if (currentBrick.supportedBy.every(fallen.contains)) {
      fallen.add(currentBrick);
      nextBricks.addAll(currentBrick.supports);
    } else if (currentBrick.supportedBy.any(nextBricks.contains)) {
      nextBricks.add(currentBrick);
    }
  }
  return fallen.length - 1;
}
