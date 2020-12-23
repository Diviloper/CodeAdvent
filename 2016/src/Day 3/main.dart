import 'dart:io';

void main() {
  first();
  second();
}

class Triangle {
  final int a;
  final int b;
  final int c;

  Triangle(this.a, this.b, this.c);

  factory Triangle.fromString(String s) {
    final parts = s.split(' ').where((element) => element.isNotEmpty).map(int.parse).toList();
    return Triangle(parts[0], parts[1], parts[2]);
  }

  bool get possible => a < b + c && b < a + c && c < a + b;
}

void first() {
  final triangles = File('src/Day 3/input.txt').readAsLinesSync().map((l) => Triangle.fromString(l)).toList();
  print(triangles.where((triangle) => triangle.possible).length);
}

void second() {
  final sides = File('src/Day 3/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(' ').where((element) => element.isNotEmpty).map(int.parse).toList());
  final orderedSides =
      sides.map((e) => e[0]).followedBy(sides.map((e) => e[1])).followedBy(sides.map((e) => e[2])).toList();
  int count = 0;
  for (int i = 0; i < orderedSides.length; i += 3) {
    if (Triangle(orderedSides[i], orderedSides[i + 1], orderedSides[i + 2]).possible) ++count;
  }
  print(count);
}
