class Monkey {
  final List<int> items;
  final int Function(int) operation;
  final int test;
  final int trueMonkey;
  final int falseMonkey;

  Monkey(
      this.items, this.operation, this.test, this.trueMonkey, this.falseMonkey);
}

List<Monkey> createMonkeys() => [
      Monkey([54, 61, 97, 63, 74], (old) => old * 7, 17, 5, 3),
      Monkey([61, 70, 97, 64, 99, 83, 52, 87], (old) => old + 8, 2, 7, 6),
      Monkey([60, 67, 80, 65], (old) => old * 13, 5, 1, 6),
      Monkey([61, 70, 76, 69, 82, 56], (old) => old + 7, 3, 5, 2),
      Monkey([79, 98], (old) => old + 2, 7, 0, 3),
      Monkey([72, 79, 55], (old) => old + 1, 13, 2, 1),
      Monkey([63], (old) => old + 4, 19, 7, 4),
      Monkey([72, 51, 93, 63, 80, 86, 81], (old) => old * old, 11, 0, 4),
    ];
//   Monkey([79, 98], (old) => old * 19, 23, 2, 3),
//   Monkey([54, 65, 75, 74], (old) => old + 6, 19, 2, 0),
//   Monkey([79, 60, 97], (old) => old * old, 13, 1, 3),
//   Monkey([74], (old) => old + 3, 17, 0, 1),
// ];

void main() {
  List<Monkey> monkeys = createMonkeys();
  monkeyBusiness(monkeys, (e) => e ~/ 3, 20);

  monkeys = createMonkeys();
  final reduction = monkeys.fold<int>(1, (acc, monkey) => acc * monkey.test);
  monkeyBusiness(monkeys, (e) => e % reduction, 10000);
}

void monkeyBusiness(
    List<Monkey> monkeys, int Function(int) worryReduction, int rounds) {
  List<int> inspections = List.filled(monkeys.length, 0);
  for (int round = 0; round < rounds; ++round) {
    for (int i = 0; i < monkeys.length; i++) {
      final monkey = monkeys[i];
      inspections[i] += monkey.items.length;
      for (final item in monkey.items) {
        final newItem = worryReduction(monkey.operation(item));
        if (newItem % monkey.test == 0) {
          monkeys[monkey.trueMonkey].items.add(newItem);
        } else {
          monkeys[monkey.falseMonkey].items.add(newItem);
        }
      }
      monkey.items.clear();
    }
  }
  print((inspections..sort((a, b) => b.compareTo(a))).first * inspections[1]);
}
