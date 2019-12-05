import 'dart:io';

void main() {
  List<int> frequencyChanges =
      File("input.txt").readAsLinesSync().map(int.parse).toList();
  Set<int> frequencies = {};
  int frequency = 0;
  int i=0;
  while (!frequencies.contains(frequency)) {
    frequencies.add(frequency);
    frequency += frequencyChanges[i++];
    i %= frequencyChanges.length;
  }
  print(frequency);
}
