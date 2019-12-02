import 'dart:io';

void main() {
  final file = new File('./input.txt');
  List<String> inputLines = file.readAsLinesSync();
  print(inputLines.map((String massString) => (int.parse(massString)/3).floor() - 2).reduce((v, e) => v + e));
}