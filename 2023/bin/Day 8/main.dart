import 'dart:io';

import '../common.dart';

typedef Portal = (String, (String, String));
typedef PortalMap = Map<String, (String, String)>;

void main() {
  final input = File('./bin/Day 8/input.txt').readAsStringSync().split('\n\n');
  final instructions = input.first.split('');
  final portals = input.last.split('\n').map(processNode).toMap();

  print(getNumSteps(portals, instructions));
  print(getParallelNumSteps(portals, instructions));
}

Portal processNode(String source) {
  final match = RegExp(r'^(\w{3}) = \((\w{3}), (\w{3})\)$').firstMatch(source)!;
  return (match[1]!, (match[2]!, match[3]!));
}

int getNumSteps(PortalMap portals, List<String> instructions) {
  return getNumStepsFromTo(portals, instructions, 'AAA', ['ZZZ']);
}

int getNumStepsFromTo(
  PortalMap portals,
  List<String> instructions,
  String from,
  List<String> to,
) {
  String currentPortal = from;
  int numSteps = 0;
  for (final instruction in instructions.infinite) {
    if (to.contains(currentPortal)) break;
    final options = portals[currentPortal]!;
    currentPortal = instruction == 'L' ? options.$1 : options.$2;
    numSteps++;
  }
  return numSteps;
}

int getParallelNumSteps(PortalMap portals, List<String> instructions) {
  final endPortals =
      portals.keys.where((element) => element.endsWith('Z')).toList();
  final initialPortals = portals.keys.where((element) => element.endsWith('A'));
  final steps = initialPortals
      .map((e) => getNumStepsFromTo(portals, instructions, e, endPortals));

  return steps.lcm;
}
