import 'dart:math';

void main() {
  final target = 34000000;
  Map<int, Set<int>> memory = {
    1: {1},
  };
  int house = 1;
  int housePresents = presents(memory, house) * 10;
  while (housePresents < target) {
    housePresents = presents(memory, ++house) * 10;
    print('House $house => $housePresents presents');
  }
  final wrong = memory.entries.toList()
    ..removeWhere((entry) => entry.value
        .every((factor) => entry.key % factor == 0 && entry.value.contains(entry.key ~/ factor)));
  if (wrong.isNotEmpty) {
    print('Wrong factors');
  } else {
    print('Correct factors');
  }
  Map<int, int> elves = {};
  house = 1;
  housePresents = presentsWithLimit(memory, house, elves, 50) * 11;
  while (housePresents < target) {
    housePresents = presentsWithLimit(memory, ++house, elves, 50) * 11;
    print('House $house => $housePresents presents');
  }
}

int presentsWithLimit(Map<int, Set<int>> memory, int house, Map<int, int> elves, int limit) {
  final remainingElves =
      factors(memory, house).where((factor) => !elves.containsKey(factor) || elves[factor] < limit);
  final presents = remainingElves.fold<int>(0, (a, b) => a + b);
  for (final elf in remainingElves) {
    elves.update(elf, (value) => value + 1, ifAbsent: () => 1);
  }
  return presents;
}

int presents(Map<int, Set<int>> memory, int house) {
  return factors(memory, house).fold<int>(0, (presents, elf) => presents + elf);
}

Set<int> factors(Map<int, Set<int>> memory, int n) {
  if (!memory.containsKey(n)) {
    memory[n] = n.factors;
  }
  return memory[n];
}

extension on int {
  Set<int> get lowFactors => {
        for (int i = 1; i <= sqrt(this).ceil(); i++) if (this % i == 0) i,
      };

  Set<int> get factors {
    final lows = lowFactors;
    return {
      ...lows,
      for (final low in lows) this ~/ low,
    };
  }
}
