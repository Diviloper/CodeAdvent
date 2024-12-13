import 'dart:io';

import 'package:collection/collection.dart';
import 'package:cassowary/cassowary.dart';

import '../common.dart';
import '../directions.dart';

class Machine {
  final Position a;
  final Position b;
  final Position prize;

  Machine(this.a, this.b, this.prize);

  @override
  String toString() => "A: $a, B: $b, Prize: $prize";
}

void main() {
  final input = File('./input.txt')
      .readAsStringSync()
      .split('${Platform.lineTerminator}${Platform.lineTerminator}')
      .map(parseMachine)
      .toList();

  final first = input.map(solveMachine).sum;
  print(first);
}

Machine parseMachine(String source) {
  final reg = RegExp(r".* X[+=](\d+), Y[+=](\d+)");
  final [a, b, prize] = source
      .split(Platform.lineTerminator)
      .map(reg.matchAsPrefix)
      .map((match) => (
            int.parse(match!.group(1)!),
            int.parse(match.group(2)!),
          ))
      .zippedMap(Position.fromCoords)
      .toList();
  return Machine(a, b, prize);
}

int solveMachine(Machine machine, [int minA = 0, int maxA = 100]) {
  final solver = Solver();

  final ax = cm(machine.a.i.toDouble());
  final ay = cm(machine.a.j.toDouble());
  final bx = cm(machine.b.i.toDouble());
  final by = cm(machine.b.j.toDouble());

  final px = cm(machine.prize.i.toDouble());
  final py = cm(machine.prize.j.toDouble());

  final aPresses = Param();
  final bPresses = Param();

  final xConstraint = (ax * aPresses + bx * bPresses).equals(px);
  final yConstraint = (ay * aPresses + by * bPresses).equals(py);

  final aConstraintMin = aPresses >= cm(minA.toDouble());
  final aConstraintMax = aPresses <= cm(maxA.toDouble());
  final bConstraintMin = bPresses >= cm(0);
  final bConstraintMax = bPresses <= cm(100);

  final tokens = Param();

  final tokenConstraint = tokens.equals(aPresses * cm(3) + bPresses * cm(1));

  solver
    ..addConstraints([
      xConstraint,
      yConstraint,
      aConstraintMax,
      aConstraintMin,
      bConstraintMax,
      bConstraintMin,
      tokenConstraint,
    ])
    ..flushUpdates();

  print("${aPresses.value} | ${bPresses.value} | ${tokens.value}");

  if (aPresses.value % 1 > 0.1 && aPresses.value % 1 < 0.9) {
    print("Simplex time");
    final left = solveMachine(machine, aPresses.value.ceil());
    if (left == 0) return solveMachine(machine, 0, aPresses.value.floor());
    return left;
  }
  if (tokens.value.toInt() != 0) {
    assert(aPresses.value.round() * 3 + bPresses.value.round() ==
        tokens.value.round());
  }

  return tokens.value.round();
}
