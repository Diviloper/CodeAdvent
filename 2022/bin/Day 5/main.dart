import 'dart:io';

/*
        [H]     [W] [B]
    [D] [B]     [L] [G] [N]
[P] [J] [T]     [M] [R] [D]
[V] [F] [V]     [F] [Z] [B]     [C]
[Z] [V] [S]     [G] [H] [C] [Q] [R]
[W] [W] [L] [J] [B] [V] [P] [B] [Z]
[D] [S] [M] [S] [Z] [W] [J] [T] [G]
[T] [L] [Z] [R] [C] [Q] [V] [P] [H]
 1   2   3   4   5   6   7   8   9
 */

void main() {
  List<String> moves = File('./input.txt').readAsLinesSync();
  List<List<String>> stacks = [
    ['T', 'D', 'W', 'Z', 'V', 'P'],
    ['L', 'S', 'W', 'V', 'F', 'J', 'D'],
    ['Z', 'M', 'L', 'S', 'V', 'T', 'B', 'H'],
    ['R', 'S', 'J'],
    ['C', 'Z', 'B', 'G', 'F', 'M', 'L', 'W'],
    ['Q', 'W', 'V', 'H', 'Z', 'R', 'G', 'B'],
    ['V', 'J', 'P', 'C', 'B', 'D', 'N'],
    ['P', 'T', 'B', 'Q'],
    ['H', 'G', 'Z', 'R', 'C']
  ];

  topsAfterMoves(stacks, moves);

  stacks = [
    ['T', 'D', 'W', 'Z', 'V', 'P'],
    ['L', 'S', 'W', 'V', 'F', 'J', 'D'],
    ['Z', 'M', 'L', 'S', 'V', 'T', 'B', 'H'],
    ['R', 'S', 'J'],
    ['C', 'Z', 'B', 'G', 'F', 'M', 'L', 'W'],
    ['Q', 'W', 'V', 'H', 'Z', 'R', 'G', 'B'],
    ['V', 'J', 'P', 'C', 'B', 'D', 'N'],
    ['P', 'T', 'B', 'Q'],
    ['H', 'G', 'Z', 'R', 'C']
  ];
  topsAfterMovesTogether(stacks, moves);
}

void topsAfterMovesTogether(List<List<String>> stacks, List<String> moves) {
  for (String move in moves) {
    List<String> parts = move.split(' ');
    int amount = int.parse(parts[1]);
    int from = int.parse(parts[3]) - 1;
    int to = int.parse(parts[5]) - 1;
    final fromLength = stacks[from].length;
    stacks[to].addAll(stacks[from].sublist(fromLength - amount));
    stacks[from].removeRange(fromLength - amount, fromLength);
  }
  print(stacks.map((e) => e.last).join(''));
}

void topsAfterMoves(List<List<String>> stacks, List<String> moves) {
  for (String move in moves) {
    List<String> parts = move.split(' ');
    int amount = int.parse(parts[1]);
    int from = int.parse(parts[3]) - 1;
    int to = int.parse(parts[5]) - 1;
    for (int i = 0; i < amount; ++i) {
      stacks[to].add(stacks[from].removeLast());
    }
  }
  print(stacks.map((e) => e.last).join(''));
}
