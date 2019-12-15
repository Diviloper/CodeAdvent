import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

class Angle extends Equatable {
  final int x, y, gcd;
  final double angle;

  Angle(this.x, this.y)
      : gcd = x.gcd(y) == 0 ? 1 : x.gcd(y),
        angle = atan2(y, x) - pi;

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
}

int asteroidsDetected(List<List<String>> input, int x0, int y0) {
  Set<Angle> angles = {};
  for (int x = 0; x < input.length; ++x) {
    for (int y = 0; y < input[x].length; ++y) {
      if (input[x][y] == '.') continue;
      angles.add(Angle(x - x0, y - y0));
    }
  }
  return angles.length;
}
