import 'dart:io';

void main() {
  final entries = File('./input.txt')
      .readAsLinesSync()
      .map(int.parse)
      .where((element) => element <= 2020)
      .toList();
  first(entries);
  second(entries);
}

void first(List<int> entries) {
  for (int i = 0; i < entries.length; ++i) {
    for (int j = i + 1; j < entries.length; ++j) {
      if (entries[i] + entries[j] == 2020) {
        print(entries[i] * entries[j]);
      }
    }
  }
}

void second(List<int> entries) {
  for (int i = 0; i < entries.length; ++i) {
    for (int j = i + 1; j < entries.length; ++j) {
      for (int k = j + 1; k < entries.length; ++k) {
        if (entries[i] + entries[j] + entries[k] == 2020) {
          print(entries[i] * entries[j] * entries[k]);
        }
      }
    }
  }
}
