import 'dart:io';

List<int> differences(String first, String second) {
  List<int> diffs = [];
  for (int i=0; i<first.length; ++i) {
    if (first[i] != second[i]) diffs.add(i);
  }
  return diffs;
}

void main() {
  List<String> input = File("input.txt").readAsLinesSync();
  for (int i=0; i<input.length; ++i) {
    for (int j=i+1; j<input.length; ++j) {
      final diffs = differences(input[i], input[j]);
      if (diffs.length == 1){
        print(input[i].replaceRange(diffs[0], diffs[0]+1, ''));
        print(input[i]);
        return;
      }
    }
  }
}