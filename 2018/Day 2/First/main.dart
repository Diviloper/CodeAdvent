import 'dart:io';

extension on String {
  int hasExactly2And3OfALetter() {
    Map<String, int> occurrences = {};
    this
        .split('')
        .forEach((v) => occurrences.update(v, (i) => i + 1, ifAbsent: () => 1));
    int h = 0;
    if (occurrences.values.contains(2)) ++h;
    if (occurrences.values.contains(3)) h += 2;
    return h;
  }
}

void main() {
  List<String> ids = File("input.txt").readAsLinesSync();
  int h2 = 0, h3 = 0;
  for (var id in ids) {
    switch(id.hasExactly2And3OfALetter()) {
      case 1:
        ++h2;
        break;
      case 2:
        ++h3;
        break;
      case 3:
        ++h2;
        ++h3;
    }
  }
  print(h2 * h3);
}
