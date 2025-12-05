import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

typedef Range = (int, int);

void main() {
  final (db, ingredients) = readInput();
  first(db, ingredients);
  second(db);
}

(List<Range>, List<int>) readInput() {
  final [dbInput, ingredientInput] = File('./input.txt')
      .readAsStringSync()
      .split('${Platform.lineTerminator}${Platform.lineTerminator}');
  final db = dbInput
      .split(Platform.lineTerminator)
      .map((rs) => rs.split("-").map(int.parse).toList())
      .map((l) => (l.first, l.last))
      .toList();
  final ingredients = ingredientInput
      .split(Platform.lineTerminator)
      .map(int.parse)
      .toList();
  return (db, ingredients);
}

void first(List<Range> db, List<int> ingredients) {
  final fresh = ingredients
      .where((ing) => db.any((range) => ing >= range.$1 && ing <= range.$2))
      .length;
  print(fresh);
}

void second(List<Range> db) {
  int previousDB;
  do {
    previousDB = db.length;
    db = collapseDB(db);
  } while (db.length != previousDB);
  int freshIngredients = db.map((r) => r.$2 - r.$1 + 1).sum;
  print(freshIngredients);
}

List<Range> collapseDB(List<Range> db) {
  final newDB = <Range>[];
  for (int i = 0; i < db.length; ++i) {
    Range range = db[i];
    for (int j = i + 1; j < db.length; ++j) {
      if (overlap(db[i], db[j])) range = merge(range, db.removeAt(j--));
    }
    newDB.add(range);
  }
  return newDB;
}

bool overlap(Range first, Range second) {
  return !(first.$2 < second.$1 || second.$2 < first.$1);
}

Range merge(Range first, Range second) {
  return (min(first.$1, second.$1), max(first.$2, second.$2));
}
