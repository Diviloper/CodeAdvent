import 'dart:io';

void main() {
  final file = new File('./input.txt');
  List<String> inputLines = file.readAsLinesSync();
  print(inputLines
      .map((mass) => calculateFuel(int.parse(mass)))
      .reduce((v, e) => v + e));
}

int calculateFuel(int mass) {
  int fuel = (mass/3).floor() - 2;
  return fuel > 0 ? fuel + calculateFuel(fuel) : 0;
}
