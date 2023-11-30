import 'dart:io';

void main() {
  final fishes =
      File('./input.txt').readAsStringSync().split(',').map(int.parse).toList();
  getFishesAfterDays(fishes, 80);
  getFishesAfterDays(fishes, 256);
}

void getFishesAfterDays(List<int> fishes, int days) {
  List<int> counters = List.filled(9, 0);
  for (final fish in fishes) {
    counters[fish]++;
  }
  for (int i = 0; i < days; ++i) {
    counters = [
      for (int i = 1; i <= 6; ++i) counters[i],
      counters[0] + counters[7],
      counters[8],
      counters[0]
    ];
  }
  print(counters.reduce((v, e) => v + e));
}
