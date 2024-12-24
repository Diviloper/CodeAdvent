import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

enum Gate {
  and(),
  or(),
  xor();

  const Gate();

  factory Gate.fromString(String source) =>
      switch (source.toLowerCase()) {
        "and" => Gate.and,
        "or" => Gate.or,
        "xor" => Gate.xor,
        _ => throw Exception("Invalid value"),
      };

  bool operate(bool left, bool right) =>
      switch (this) {
        Gate.and => left & right,
        Gate.or => left | right,
        Gate.xor => left ^ right,
      };
}

void main() {
  final [initialInput, gatesInput] = File('./input.txt')
      .readAsStringSync()
      .split('${Platform.lineTerminator}${Platform.lineTerminator}')
      .map((l) => l.split(Platform.lineTerminator))
      .toList();

  final initialValues = Map<String, bool>.fromEntries(initialInput
      .map((line) => line.split(": "))
      .map((l) => MapEntry(l.first, l.last == "1")));
  final re = RegExp(r"^(\w+) (AND|OR|XOR) (\w+) -> (\w+)$");
  final gates = gatesInput
      .map((line) => re.firstMatch(line)!)
      .map((match) =>
  (Gate.fromString(match[2]!), match[1]!, match[3]!, match[4]!))
      .toList();

  final first = circuitResult(gates, initialValues);
  print(first);

  analyze(initialValues, gates);

  final swappedGates = [
    "djg",
    "z12",
    "sbg",
    "z19",
    "hjm",
    "mcq",
    "dsd",
    "z37",
  ]..sort();
  print(swappedGates.join(','));
}

Map<String, bool> runCircuit(List<(Gate, String, String, String)> gates,
    Map<String, bool> initialValues,) {
  final values = Map<String, bool>.from(initialValues);
  final remainingGates = gates.copy();

  while (remainingGates.isNotEmpty) {
    final entry = remainingGates.firstWhereOrNull(
            (gate) =>
        values.containsKey(gate.$2) && values.containsKey(gate.$3));
    if (entry == null) break;
    final (gate, left, right, out) = entry;
    remainingGates.remove((gate, left, right, out));
    values[out] = gate.operate(values[left]!, values[right]!);
  }

  return values;
}

int circuitResult(List<(Gate, String, String, String)> gates,
    Map<String, bool> initialValues,) {
  final result = runCircuit(gates, initialValues);
  final binary = result.keys
      .where((key) => key.startsWith("z"))
      .sorted((a, b) => b.compareTo(a))
      .map((key) => result[key]! ? "1" : "0")
      .join();
  return int.parse(binary, radix: 2);
}

void analyze(Map<String, bool> initialValues,
    List<(Gate, String, String, String)> gates) {
  final sortedGates = gates
      .map((gate) =>
  gate.$2.compareTo(gate.$3) <= 0
      ? gate
      : (gate.$1, gate.$3, gate.$2, gate.$4))
      .toList();

  sortedGates.sorted((a, b) => a.$2.compareTo(b.$2)).printIterable().toList();

  String carryIn = sortedGates
      .singleWhere(
          (gate) => gate.$1 == Gate.and && gate.$2 == "x00" && gate.$3 == "y00")
      .$4;
  // ktt
  for (int i = 1; i < 45; ++i) {
    final x = "x${i.toString().padLeft(2, "0")}";
    final y = "y${i.toString().padLeft(2, "0")}";
    final z = "z${i.toString().padLeft(2, "0")}";

    // x01 XOR y01 -> rvb
    final digitSumGate = sortedGates.singleWhereOrNull(
            (gate) => gate.$1 == Gate.xor && gate.$2 == x && gate.$3 == y);
    if (digitSumGate == null) {
      print("Digit sum gate for $x XOR $y not found");
      break;
    }
    final digitSum = digitSumGate.$4;

    // x01 AND y01 -> kgp
    final carryGate = sortedGates.singleWhereOrNull(
            (gate) => gate.$1 == Gate.and && gate.$2 == x && gate.$3 == y);
    if (carryGate == null) {
      print("Digit carry gate for $x AND $y not found");
      break;
    }
    final carry = carryGate.$4;

    // ktt XOR rvb -> z01
    final resultGate = sortedGates.singleWhereOrNull((gate) =>
    gate.$1 == Gate.xor &&
        ((gate.$2 == digitSum && gate.$3 == carryIn) ||
            (gate.$2 == carryIn && gate.$3 == digitSum)));
    if (resultGate == null) {
      print("Result gate for $digitSum XOR $carryIn not found");
      final digitSumCandidates = sortedGates
          .where((gate) =>
      gate.$1 == Gate.xor &&
          (gate.$2 == digitSum || gate.$3 == digitSum))
          .join(', ');
      print("Candidate with digit sum $digitSum: $digitSumCandidates");
      final carryInCandidates = sortedGates
          .where((gate) =>
      gate.$1 == Gate.xor &&
          (gate.$2 == carryIn || gate.$3 == carryIn))
          .join(', ');
      print("Candidate with previous carry $carryIn: $carryInCandidates");
      break;
    }
    final result = resultGate.$4;
    if (result != z) {
      print("Gate $resultGate should have output $z");
    }

    // ktt AND rvb -> kmb
    final carryInSumGate = sortedGates.singleWhereOrNull((gate) =>
    gate.$1 == Gate.and &&
        ((gate.$2 == digitSum && gate.$3 == carryIn) ||
            (gate.$2 == carryIn && gate.$3 == digitSum)));
    if (carryInSumGate == null) {
      print("Carry in sum gate for $digitSum AND $carryIn not found");
      break;
    }
    final carryInSum = carryInSumGate.$4;

    // kgp OR kmb -> rkn
    final carryForNextGate = sortedGates.singleWhereOrNull((gate) =>
    gate.$1 == Gate.or &&
        ((gate.$2 == carry && gate.$3 == carryInSum) ||
            (gate.$2 == carryInSum && gate.$3 == carry)));
    if (carryForNextGate == null) {
      print("Carry for next gate for $carry XOR $carryInSum not found");
      break;
    }
    carryIn = carryForNextGate.$4;
  }
}
