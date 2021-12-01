import 'dart:collection';
import 'dart:io';
import '../common.dart';

void main() {
  final dependencies =
      File('input.txt').readAsLinesSync().map((e) => Tuple(e.substring(36, 37), e.substring(5, 6))).toList();
  final steps = dependencies.expand((element) => [element.first, element.second]).toSet();
  final dependencyMap = <String, List<String>>{};
  for (final dependency in dependencies) {
    dependencyMap.update(
      dependency.first,
      (value) => value..add(dependency.second),
      ifAbsent: () => [dependency.second],
    );
  }
  getOrderOfSteps(steps, dependencyMap);
  calculateParallelTime(steps, dependencyMap);
}

void calculateParallelTime(Set<String> steps, Map<String, List<String>> dependencyMap) {
  final stepDuration = {
    for (final step in steps) step: 61 + step.codeUnitAt(0) - 'A'.codeUnitAt(0),
  };
  int seconds = -1;
  final done = [];
  final currentWork = List.filled(5, ' ');
  final remainingTime = List.filled(5, -1);
  final nextSteps = SplayTreeSet.of(steps.where((step) => !dependencyMap.containsKey(step)));
  while (done.length < steps.length) {
    for (int i = 0; i < 5; i++) {
      if (remainingTime[i] == 0) {
        done.add(currentWork[i]);
        nextSteps.addAll(dependencyMap.keys.where((step) =>
            !done.contains(step) && !currentWork.contains(step) && dependencyMap[step]!.every(done.contains)));
        currentWork[i] = ' ';
        remainingTime[i] = -1;
      }
    }
    for (int i = 0; i < 5; ++i) {
      if (remainingTime[i] < 0) {
        if (nextSteps.isNotEmpty) {
          currentWork[i] = nextSteps.first;
          nextSteps.remove(currentWork[i]);
          remainingTime[i] = stepDuration[currentWork[i]]!;
        }
      }
      remainingTime[i]--;
    }
    ++seconds;
  }
  print(seconds);
}

void getOrderOfSteps(Set<String> steps, Map<String, List<String>> dependencyMap) {
  final order = [];
  final nextInstructions = SplayTreeSet.of(steps.where((step) => !dependencyMap.containsKey(step)));
  while (nextInstructions.isNotEmpty) {
    final nextInstruction = nextInstructions.first;
    nextInstructions.remove(nextInstruction);
    order.add(nextInstruction);
    nextInstructions.addAll(
        dependencyMap.keys.where((step) => !order.contains(step) && dependencyMap[step]!.every(order.contains)));
  }
  print(order.join());
}
