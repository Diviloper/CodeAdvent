import 'dart:io';

void main() {
  List<String> data = File('./input.txt').readAsStringSync().split('');
  firstMarker(data, 4);
  firstMarker(data, 14);
}

void firstMarker(List<String> data, int size) {
  int i;
  for (i = size; i < data.length; ++i) {
    if (data.sublist(i - size, i).toSet().length == size) break;
  }
  print(i);
}
