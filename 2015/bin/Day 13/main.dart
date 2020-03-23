import 'dart:io';
import 'dart:math';

import 'package:trotter/trotter.dart';

void main() {
  'Alice would lose 2 happiness units by sitting next to Bob.';
  final input = File('input.txt').readAsLinesSync();
  final regexp = RegExp(r'^([a-zA-Z]+)\ would\ ([a-z]+)\ ([0-9]+)\ happiness\ units\ '
      r'by\ sitting\ next\ to\ ([a-zA-Z]+)\.$');
  final happiness = <String, Map<String, int>>{};
  for (final line in input) {
    final match = regexp.firstMatch(line);
    final firstPerson = match.group(1);
    final reaction = match.group(2);
    final points = int.parse(match.group(3)) * (reaction == 'lose' ? -1 : 1);
    final secondPerson = match.group(4);
    happiness.update(
      firstPerson,
      (neighbors) => neighbors..[secondPerson] = points,
      ifAbsent: () => {secondPerson: points},
    );
  }

  final people = happiness.keys.toList()..add('You');
  final permutations = Permutations(people.length, people);
  int maxHappiness = happiness.values.fold<int>(0, (h, person) => h + person.values.reduce(min));
  for (final permutation in permutations()) {
    maxHappiness = max(maxHappiness, happinessOf(permutation, happiness));
  }
  print(maxHappiness);
}

int happinessOf(List<String> permutation, Map<String, Map<String, int>> happiness) {
  int total = 0;
  String current = permutation.last;
  for (final neighbour in permutation) {
    if (current != 'You' && neighbour != 'You') {
      total += happiness[current][neighbour] + happiness[neighbour][current];
    }
    current = neighbour;
  }
  return total;
}
