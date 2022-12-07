import 'dart:io';
import 'package:collection/collection.dart';

void main() {
  List<String> rucksacks = File('./input.txt').readAsLinesSync();
  sumOfTopPriority(rucksacks);
  badgePriority(rucksacks);
}

void badgePriority(List<String> rucksacks) {
  int prioritySum = [
    for (int i = 0; i < rucksacks.length; i += 3)
      badge(rucksacks.sublist(i, i + 3))
  ].map(priorityValue).sum;
  print(prioritySum);
}

String badge(List<String> rucksacks) {
  return rucksacks
      .map((e) => e.split('').toSet())
      .reduce((value, element) => value.intersection(element))
      .single;
}

void sumOfTopPriority(List<String> rucksacks) {
  int prioritySum = rucksacks.map(misplacedElement).map(priorityValue).sum;
  print(prioritySum);
}

int priorityValue(String element) {
  if (element.toUpperCase() == element) {
    return element.codeUnitAt(0) - 'A'.codeUnitAt(0) + 27;
  }
  return element.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1;
}

String misplacedElement(String rucksack) {
  Set<String> first =
      rucksack.substring(0, rucksack.length ~/ 2).split('').toSet();
  Set<String> second =
      rucksack.substring(rucksack.length ~/ 2).split('').toSet();
  return first.intersection(second).single;
}
