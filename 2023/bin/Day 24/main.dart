import 'dart:io';

import 'package:z3/z3.dart';

import '../common.dart';

typedef SemiLine = ({Position3D start, Position3D direction});
typedef Line2D = ({double slope, double intercept});

void main() {
  final lines = File('./bin/Day 24/input.txt')
      .readAsLinesSync()
      .map(processLine)
      .toList();
  final start = (x: 200000000000000, y: 200000000000000, z: 0);
  final end = (x: 400000000000000, y: 400000000000000, z: 0);
  int count = 0;
  for (final (first, second) in lines.triangularProduct()) {
    if (willIntersect2D(first, second, start, end)) {
      ++count;
    }
  }
  print(count);

  solveZ3(lines);
}

void solveZ3(List<SemiLine> lines) async {
  final s = solver();
  final x0 = constVar('X0', intSort);
  final xd = constVar('Xd', intSort);
  final y0 = constVar('Y0', intSort);
  final yd = constVar('Yd', intSort);
  final z0 = constVar('Z0', intSort);
  final zd = constVar('Zd', intSort);

  for (final (index, (start: start, direction: dir)) in lines.indexed.take(3)) {
    final t = constVar('t$index', realSort);
    s.add(t >= 0);
    s.add((x0 + t * xd - start.x - t * dir.x).eq(0));
    s.add((y0 + t * yd - start.y - t * dir.y).eq(0));
    s.add((z0 + t * zd - start.z - t * dir.z).eq(0));
  }
  final model = s.ensureSat();
  final c = model.evalConst;
  print('(${c(x0)},${c(y0)},${c(z0)}) @ (${c(xd)},${c(yd)},${c(zd)})');
}

SemiLine processLine(String line) {
  final [position, direction] = line.split(' @ ');
  return (
    start: position3DFromList(position.split(', ').map(int.parse).toList()),
    direction: position3DFromList(direction.split(', ').map(int.parse).toList())
  );
}

bool willIntersect2D(
    SemiLine first, SemiLine second, Position3D start, Position3D end) {
  final (slope: a, intercept: c) =
      get2DLineFormula(first.start, first.start + first.direction);
  final (slope: b, intercept: d) =
      get2DLineFormula(second.start, second.start + second.direction);
  if (a == b) return c == d;
  final x = (d - c) / (a - b);
  final y = a * x + c;

  bool isPastFirst = ((x - first.start.x) / first.direction.x) < 0;
  bool isPastSecond = ((x - second.start.x) / second.direction.x) < 0;
  if (isPastFirst || isPastSecond) return false;

  return (start.x <= x && x <= end.x && start.y <= y && y <= end.y);
}

Line2D get2DLineFormula(Position3D a, Position3D b) {
  final m = (b.y - a.y) / (b.x - a.x);
  final o = a.y - (m * a.x);
  return (slope: m, intercept: o);
}
