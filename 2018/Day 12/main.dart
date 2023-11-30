import 'dart:collection';
import 'dart:io';

void main() {
  final lines = File('input.txt').readAsLinesSync();

  numberOfPlantsAfterGenerations(lines, 20);
  numberOfPlantsAfterGenerations(lines, 50000000000);
}

void numberOfPlantsAfterGenerations(List<String> lines, int generations) {
  Set<int> state = SplayTreeSet.of(
      lines.first.split('').sublist(15).asMap().entries.where((entry) => entry.value == '#').map((entry) => entry.key));
  List<String> stateHistory = [];
  final patterns = lines
      .skip(2)
      .where((e) => e.endsWith('#'))
      .map((e) => e.split(' => ')[0])
      .map((e) => e.split('').map((e) => e == '#').toList())
      .toList();

  for (int generation = 0; generation < generations; ++generation) {
    stateHistory.add(state.join('|'));
    final nextState = SplayTreeSet<int>();
    for (int pot = state.first - 2; pot <= state.last + 2; ++pot) {
      for (final pattern in patterns) {
        if (matches(state, pot, pattern)) nextState.add(pot);
      }
    }
    state = nextState;
    if (stateHistory.contains(nextState.join('|'))) break;
  }
  if (stateHistory.contains(state.join('|'))) {
    final index = stateHistory.indexOf(state.join('|'));
    final loopWidth = stateHistory.length - index;
    final endStateIndex = index + (generations - index) % loopWidth;
    state = stateHistory[endStateIndex].split('|').map(int.parse).toSet();
  }
  print(state.reduce((value, element) => value + element));
}

bool matches(Set<int> plants, int plant, List<bool> pattern) {
  for (int i = 0; i < 5; ++i) {
    if (pattern[i] != plants.contains(plant + i - 2)) return false;
  }
  return true;
}
