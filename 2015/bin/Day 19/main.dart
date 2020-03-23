import 'dart:collection';
import 'dart:io';

void main() {
  final formulas = File('input.txt').readAsLinesSync().where((line) => line.isNotEmpty).toList();
  final molecule = formulas.removeLast();
  final transformations = formulas
      .map((formula) => formula.split(' => '))
      .map((parts) => Formula(parts.first, parts.last));
  final results = <String>{};
  for (final transformation in transformations) {
    final regexp = RegExp(transformation.from);
    final matches = regexp.allMatches(molecule);
    for (final match in matches) {
      results.add(molecule.replaceRange(match.start, match.end, transformation.to));
    }
  }
  Set<String> visitedMolecules = {};
  final stack = Queue<String>()..addFirst(molecule);
  while (stack.isNotEmpty) {
    final currentMolecule = stack.first;
    if (currentMolecule == 'e') {
      print(stack.toList().reversed.join(' =>\n'));
      print(stack.length-1);
    }
    final next = getFirstUnvisitedMolecule(currentMolecule, transformations, visitedMolecules);
    if (next == null) {
      stack.removeFirst();
    } else {
      visitedMolecules.add(next);
      stack.addFirst(next);
    }
  }
}

String getFirstUnvisitedMolecule(
  String currentMolecule,
  Iterable<Formula> transformations,
  Set<String> visitedMolecules,
) {
  for (final transformation in transformations) {
    final regexp = RegExp(transformation.to);
    final matches = regexp.allMatches(currentMolecule);
    for (final match in matches) {
      final newMolecule = currentMolecule.replaceRange(match.start, match.end, transformation.from);
      if (!visitedMolecules.contains(newMolecule)) {
        return newMolecule;
      }
    }
  }
  return null;
}

class Formula {
  final String from;
  final String to;

  Formula(this.from, this.to);
}
