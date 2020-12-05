import 'dart:io';

void main() {
  final map =
      File('./input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  first(map);
  second(map);
}

void first(List<List<String>> map) {
  print(trees(map, 3, 1));
}

void second(List<List<String>> map) {
  final slopes = [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2],
  ];
  int count = 1;
  for (final slope in slopes) {
    count *= trees(map, slope.first, slope.last);
  }
  print(count);
}

int trees(List<List<String>> map, int horizontalSlope, int verticalSlope) {
  int count = 0;
  int i = 0, j = 0;
  while (j < map.length) {
    if (map[j][i] == '#') ++count;
    i = (i + horizontalSlope) % map.first.length;
    j += verticalSlope;
  }
  return count;
}
