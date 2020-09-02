import 'dart:io';

void main() {
  first();
  second();
}

List<String> spin(List<String> programs, int num) => programs
    .sublist(programs.length - num)
    .followedBy(programs.take(programs.length - num))
    .toList();

List<String> exchange(List<String> programs, int first, int second) {
  final list = List<String>.from(programs);
  final temp = list[first];
  list[first] = list[second];
  list[second] = temp;
  return list;
}

List<String> partner(List<String> programs, String first, String second) =>
    exchange(programs, programs.indexOf(first), programs.indexOf(second));

List<String> makeMove(String move, List<String> programs) {
  if (move.startsWith('s')) {
    final match = RegExp(r'^s(?<count>\d+)$').firstMatch(move);
    return spin(programs, int.parse(match.namedGroup('count')));
  } else if (move.startsWith('x')) {
    final match = RegExp(r'^x(?<first>\d+)/(?<second>\d+)$').firstMatch(move);
    return exchange(programs, int.parse(match.namedGroup('first')),
        int.parse(match.namedGroup('second')));
  } else if (move.startsWith('p')) {
    final match =
        RegExp(r'^p(?<first>[a-z])/(?<second>[a-z])$').firstMatch(move);
    return partner(
        programs, match.namedGroup('first'), match.namedGroup('second'));
  }
  throw 'Invalid move';
}

void first() {
  final moves = File('src/Day 16/input.txt').readAsStringSync().split(',');
  List<String> programs = 'abcdefghijklmnop'.split('');
  for (final move in moves) {
    programs = makeMove(move, programs);
  }
  print(programs.join());
  programs = 'abcdefghijklmnop'.split('');
}

void second() {
  final moves = File('src/Day 16/input.txt').readAsStringSync().split(',');
  final original = 'abcdefghijklmnop';
  List<String> programs = original.split('');
  int i;
  for (i = 1; i <= 1000000000; ++i) {
    for (final move in moves) {
      programs = makeMove(move, programs);
    }
    if (original == programs.join()) {
      print('Loop at ${i}');
      break;
    }
  }
  print(programs.join());
  programs = 'abcdefghijklmnop'.split('');
  final rounds = 1000000000 % i;
  print('Dancing $rounds times');
  for (int j = 0; j < rounds; ++j) {
    for (final move in moves) {
      programs = makeMove(move, programs);
    }
  }
  print(programs.join());
}
