import 'dart:io';

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

  String system = 'var int: X0;\n'
      'var int: Xd;\n\n'
      'var int: Y0;\n'
      'var int: Yd;\n\n'
      'var int: Z0;\n'
      'var int: Zd;\n\n';
  for (final (i, line) in lines.indexed) {
    system += getEquation(i, line);
  }

  system += '\nsolve satisfy;\n\n';
  system += r'output ["(\(X0),\(Y0),\(Z0)) @ (\(Xd),\(Yd),\(Zd))\n"];' '\n';
  system += r'output ["\n\(X0 + Y0 + Z0)"];';
  File('./bin/Day 24/model.txt').writeAsString(system);
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

String getEquation(int index, SemiLine line) {
  return 'var int: T$index;\n'
      'constraint T$index >= 0;\n'
      'constraint X0 + T$index * Xd == ${line.start.x} + T$index * ${line.direction.x};\n'
      'constraint Y0 + T$index * Yd == ${line.start.y} + T$index * ${line.direction.y};\n'
      'constraint Z0 + T$index * Zd == ${line.start.z} + T$index * ${line.direction.z};\n';
}
