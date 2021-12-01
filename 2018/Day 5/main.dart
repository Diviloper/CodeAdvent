import 'dart:io';

void main() {
  final polymer = File('input.txt').readAsStringSync().split('');

  collapsePolymer(polymer);
  improvePolymer(polymer);
}

void improvePolymer(List<String> polymer) {
  final components = polymer.map((e) => e.toLowerCase()).toSet();
  List<String> bestPolymer = polymer;
  int minLength = polymer.length;
  for (final removedComponent in components) {
    final newPolymer = polymer.where((element) => element.toLowerCase() != removedComponent).toList();
    while(triggerReactions(newPolymer));
    final newLength = newPolymer.length;
    if (newLength < minLength) {
      minLength = newLength;
      bestPolymer = newPolymer;
    }
  }
  print(bestPolymer.join());
  print(minLength);
}

void collapsePolymer(List<String> polymer) {
  while (triggerReactions(polymer));
  print(polymer.join());
  print(polymer.length);
}

bool triggerReactions(List<String> polymer) {
  bool reactionsTriggered = false;
  for (int i = 0; i < polymer.length - 1; ++i) {
    if (react(polymer[i], polymer[i + 1])) {
      polymer.removeRange(i, i + 2);
      reactionsTriggered = true;
    }
  }
  return reactionsTriggered;
}

bool react(String a, String b) => a != b && a.toLowerCase() == b.toLowerCase();
