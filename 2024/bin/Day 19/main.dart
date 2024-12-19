import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final [towelInput, designInput] = File('./input.txt')
      .readAsStringSync()
      .split("${Platform.lineTerminator}${Platform.lineTerminator}");
  final availableTowels = towelInput.split(', ');
  final designs = designInput.split(Platform.lineTerminator);

  final memory = {for (final towel in availableTowels) towel: true};
  final possibleDesigns =
      designs.where((d) => possible(d, availableTowels, memory)).length;
  print(possibleDesigns);

  final combinationsMemory = {"": 1};
  final numCombinations = designs
      .where((d) => possible(d, availableTowels, memory))
      .map((d) => possibleWays(d, availableTowels, combinationsMemory))
      .sum;
  print(numCombinations);
}

bool possible(String design, List<String> towels, Map<String, bool> memory) {
  if (!memory.containsKey(design)) {
    memory[design] = false;
    for (final towel in towels) {
      if (design.startsWith(towel) &&
          possible(design.substring(towel.length), towels, memory)) {
        memory[design] = true;
        break;
      }
    }
  }

  return memory[design]!;
}

int possibleWays(String design, List<String> towels, Map<String, int> memory) {
  if (!memory.containsKey(design)) {
    int count = 0;
    for (final towel in towels) {
      if (design.startsWith(towel)) {
        count += possibleWays(design.substring(towel.length), towels, memory);
      }
    }
    memory[design] = count;
  }

  return memory[design]!;
}
