import 'dart:io';


import '../common.dart';

void main() {
  final input = File('./input.txt')
      .readAsStringSync()
      .split('${Platform.lineTerminator}${Platform.lineTerminator}');

  final keys = input.where((k) => k.startsWith("#")).map(fromString).toList();
  final locks = input.where((k) => k.startsWith(".")).map(fromString).toList();

  final matching = keys.cross(locks).zippedWhere(nonOverlapping).length;
  print(matching);
}

List<int> fromString(String source) {
  final lines = source.split(Platform.lineTerminator);
  final lock = List.filled(lines.first.length, 0);
  for (final line in lines) {
    for (final (j, cell) in line.split('').indexed) {
      if (cell == "#") lock[j]++;
    }
  }
  return lock;
}

bool nonOverlapping(List<int> lock, List<int> key) =>
    lock.zip(key).zippedMap((l, k) => l + k <= 7).everyTrue;
