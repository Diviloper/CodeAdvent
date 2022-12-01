import 'dart:io';
import 'package:collection/collection.dart';

void main() {
  final calories = File('./input.txt')
      .readAsStringSync()
      .split('\n\n')
      .map((e) => e.split('\n').map(int.parse))
      .map((e) => e.sum)
      .toList();
  maxCalories(calories);
  topThreeCalories(calories);
}

void maxCalories(List<int> calories) {
  print(calories.max);
}

void topThreeCalories(List<int> calories) {
  print((calories..sort((a, b) => b.compareTo(a),)).take(3).sum);
}
