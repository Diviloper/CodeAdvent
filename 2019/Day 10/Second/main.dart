import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

class Angle extends Equatable {
  final int x, y, gcd;
  final double angle;

  Angle(this.x, this.y)
      : gcd = x.gcd(y) == 0 ? 1 : x.gcd(y),
        angle = atan2(x, y) + pi / 2 >= 0
            ? atan2(x, y) + pi / 2
            : atan2(x, y) + 5 * pi / 2;

  @override
  List<Object> get props => [x ~/ gcd, y ~/ gcd];

  @override
  String toString() => "$angle";
}

void main() {
  final input =
      File("input.txt").readAsLinesSync().map((row) => row.split('')).toList();
  Map<String, int> detected = {};
  for (int x = 0; x < input.length; ++x) {
    for (int y = 0; y < input[x].length; ++y) {
      if (input[x][y] == '.') continue;
      detected["($x,$y)"] = asteroidsDetected(input, x, y);
    }
  }
  String max = detected.keys.first;
  for (var key in detected.keys) {
    if (detected[key] > detected[max]) max = key;
  }
  print("$max : ${detected[max]}");
  int x = int.parse(max.substring(1, max.indexOf(',')));
  int y = int.parse(max.substring(max.indexOf(',') + 1, max.length - 1));
  Map<double, List<String>> angles = {};
  for (int i = 0; i < input.length; ++i) {
    for (int j = 0; j < input[i].length; ++j) {
      if (input[i][j] == '.') continue;
      angles.update(
        Angle(i - x, j - y).angle,
        (current) => current..add("($i,$j)"),
        ifAbsent: () => ["($i,$j)"],
      );
    }
  }
  angles[0].remove("($y,$x)");
  for (var key in angles.keys) {
    angles[key].sort((a, b) => comparePositions(a, b, x, y));
  }
  final sortedAngles = angles.keys.toList()..sort();
  final destructionOrder = <String>[];
  while (sortedAngles.isNotEmpty) {
    Set<double> toRemove = {};
    for (var ang in sortedAngles) {
      if (angles[ang].isEmpty)
        toRemove.add(ang);
      else
        destructionOrder.add(angles[ang].removeAt(0));
    }
    sortedAngles.removeWhere(toRemove.contains);
  }
  print(destructionOrder.join('-'));
  print(destructionOrder[199]);
}

int comparePositions(String a, String b, int x, int y) {
  int ia = int.parse(a.substring(1, a.indexOf(',')));
  int ja = int.parse(a.substring(a.indexOf(',') + 1, a.length - 1));
  int ib = int.parse(b.substring(1, b.indexOf(',')));
  int jb = int.parse(b.substring(b.indexOf(',') + 1, b.length - 1));
  return ((ia - x).abs() + (ja - y).abs())
      .compareTo((ib - x).abs() + (jb - y).abs());
}

int asteroidsDetected(List<List<String>> input, int x0, int y0) {
  Set<Angle> angles = {};
  for (int x = 0; x < input.length; ++x) {
    for (int y = 0; y < input[x].length; ++y) {
      if (input[x][y] == '.') continue;
      if (x == x0 && y == y0) continue;
      angles.add(Angle(x - x0, y - y0));
    }
  }
  return angles.length;
}
