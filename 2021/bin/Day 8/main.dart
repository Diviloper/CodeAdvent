import 'dart:io';

import '../common.dart';

void main() {
  final entries = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split(' | '))
      .map((e) => Tuple<String, String>.fromList(e))
      .map((e) => Tuple(e.first.split(' '), e.second.split(' ')))
      .toList();
  getNumberOccurrences(entries);
  decodeEntries(entries);
}

void decodeEntries(List<Tuple<List<String>, List<String>>> entries) {

}

void getNumberOccurrences(List<Tuple<List<String>, List<String>>> entries) {
  print(entries
      .map((e) => e.second)
      .map((e) =>
          e.where((element) => [2, 3, 4, 7].contains(element.length)).length)
      .reduce((value, element) => value + element));
}
