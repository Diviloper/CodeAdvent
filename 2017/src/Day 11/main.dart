import 'dart:io';

import 'dart:math';

void main() {
  first();
  second();
}

void first() {
  List<String> steps =
      File('src/Day 11/input.txt').readAsStringSync().split(',');
  List<String> stepsDone = <String>[];
  for (final step in steps) {
    addStep(stepsDone, step);
  }
  print(stepsDone.length);
}

void addStep(List<String> stepsDone, String nextStep) {
  for (int i = 0; i < stepsDone.length; ++i) {
    if (combinable(stepsDone[i], nextStep)) {
      if (opposite(stepsDone[i], nextStep)) {
        stepsDone.removeAt(i);
      } else {
        String newStep = combine(stepsDone.removeAt(i), nextStep);
        addStep(stepsDone, newStep);
      }
      return;
    }
  }
  stepsDone.add(nextStep);
}

String combine(String first, String second) {
  switch ('$first$second') {
    case 'nsw':
      return 'nw';
    case 'nse':
      return 'ne';
    case 'nenw':
      return 'n';
    case 'nes':
      return 'se';
    case 'sen':
      return 'ne';
    case 'sesw':
      return 's';
    case 'sne':
      return 'se';
    case 'snw':
      return 'sw';
    case 'swn':
      return 'nw';
    case 'swse':
      return 's';
    case 'nws':
      return 'sw';
    case 'nwne':
      return 'n';
  }
  throw ('Not combinable');
}

bool combinable(String first, String second) {
  if (first == second)
    return false;
  else if (first == 'n' && second.contains('n') ||
      second == 'n' && first.contains('n'))
    return false;
  else if (first == 's' && second.contains('s') ||
      second == 's' && first.contains('s'))
    return false;
  else if (first.contains('e') && second.contains('e') ||
      first.contains('w') && second.contains('w'))
    return false;
  else
    return true;
}

bool opposite(String first, String second) {
  if (first == 'n' && second == 's') return true;
  if (first == 'ne' && second == 'sw') return true;
  if (first == 'se' && second == 'nw') return true;
  if (first == 's' && second == 'n') return true;
  if (first == 'sw' && second == 'ne') return true;
  if (first == 'nw' && second == 'se') return true;
  return false;
}

void second() {
  List<String> steps =
      File('src/Day 11/input.txt').readAsStringSync().split(',');
  List<String> stepsDone = [];
  int maxDistance = 0;
  for (final step in steps) {
    addStep(stepsDone, step);
    maxDistance = max(maxDistance, stepsDone.length);
  }
  print(maxDistance);
}
