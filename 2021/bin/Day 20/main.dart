import 'dart:io';
import 'dart:math';

import '../common.dart';

void main() {
  final lines = File('./input.txt').readAsLinesSync();
  final enhancement = lines.first.split('').map((e) => e == '#').toList();

  var litPixels = <Tuple<int, int>>{};
  for (int i = 2; i < lines.length; ++i) {
    final line = lines[i].split('');
    for (int j = 0; j < line.length; ++j) {
      if (line[j] == '#') litPixels.add(Tuple(i - 2, j));
    }
  }

  final times = 2;

  int minI = -1 - times * 3,
      maxI = lines.length - 2 + times * 3,
      minJ = -1 - times * 3,
      maxJ = lines[2].length + times * 3;

  for (int step = 0; step < times; ++step) {
    final newLitPixels = <Tuple<int, int>>{};
    for (int i = minI; i <= maxI; ++i) {
      for (int j = minJ; j <= maxJ; ++j) {
        if (enhancedPixel(i, j, litPixels, enhancement)) {
          newLitPixels.add(Tuple(i, j));
        }
      }
    }
    litPixels = newLitPixels;
    printPicture(litPixels);
  }
  print(litPixels.length);
}

bool enhancedPixel(
  int i,
  int j,
  Set<Tuple<int, int>> litPixels,
  List<bool> enhancement,
) {
  final indexList = [
    for (int dI = -1; dI <= 1; ++dI)
      for (int dJ = -1; dJ <= 1; ++dJ)
        litPixels.contains(Tuple(i + dI, j + dJ)) ? 1 : 0,
  ];
  final index = int.parse(indexList.join(), radix: 2);
  return enhancement[index];
}

void printPicture(Set<Tuple<int, int>> litPixels) {
  final minI = litPixels.map((e) => e.first).reduce(min);
  final maxI = litPixels.map((e) => e.first).reduce(max);
  final minJ = litPixels.map((e) => e.second).reduce(min);
  final maxJ = litPixels.map((e) => e.second).reduce(max);
  for (int i = minI; i <= maxI; ++i) {
    for (int j = minJ; j <= maxJ; ++j) {
      stdout.write(litPixels.contains(Tuple(i, j)) ? '#' : '.');
    }
    stdout.writeln();
  }
}
