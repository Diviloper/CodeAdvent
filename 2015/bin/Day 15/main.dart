import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';

void main() {
  final input = File('input.txt').readAsLinesSync();
  final ingredients = input.map((line) => Ingredient.fromString(line)).toList();
  final teaspoons = 100;
  final combinations = getLists(ingredients.length, teaspoons);
  int maxScore = 0;
  for (final combination in combinations) {
    final cookieIngredients = {
      for (int i = 0; i < ingredients.length; ++i) ingredients[i]: combination[i],
    };
    final cookie = Cookie(cookieIngredients);
    if (cookie.hasNCalories(500)) {
      maxScore = max(maxScore, cookie.score);
    }
  }
  print(maxScore);
}

List<List<int>> getLists(int length, int sum) {
  final lists = <List<int>>[];
  _getLists(lists, List.filled(length, 0), 0, sum);
  return lists;
}

void _getLists(List<List<int>> lists, List<int> currentList, int index, int max) {
  if (index == currentList.length - 1) {
    currentList[index] = max;
    lists.add(List.from(currentList));
    return;
  }
  for (int i = 0; i <= max; ++i) {
    currentList[index] = i;
    _getLists(lists, currentList, index + 1, max - i);
  }
}

class Cookie {
  Map<Ingredient, int> teaspoons;

  Cookie(this.teaspoons);

  int get score {
    int capacity = teaspoons.entries
        .fold(0, (c, ingredient) => c + ingredient.key.capacity * ingredient.value);
    int durability = teaspoons.entries
        .fold(0, (d, ingredient) => d + ingredient.key.durability * ingredient.value);
    int flavor =
        teaspoons.entries.fold(0, (f, ingredient) => f + ingredient.key.flavor * ingredient.value);
    int texture =
        teaspoons.entries.fold(0, (t, ingredient) => t + ingredient.key.texture * ingredient.value);
    return [capacity, durability, flavor, texture]
        .fold(1, (current, next) => current * max(0, next));
  }

  bool hasNCalories(int calories) =>
      teaspoons.entries
          .fold(0, (c, ingredient) => c + ingredient.key.calories * ingredient.value) ==
      calories;
}

class Ingredient extends Equatable {
  final String name;
  final int capacity;
  final int durability;
  final int flavor;
  final int texture;
  final int calories;

  Ingredient(this.name, this.capacity, this.durability, this.flavor, this.texture, this.calories);

  static final _regexp = RegExp(r'^([a-zA-Z]+):\ capacity\ (\-?[0-9]+),\ durability\ (\-?[0-9]+),'
      r'\ flavor\ (\-?[0-9]+),\ texture\ (\-?[0-9]+),\ calories\ (\-?[0-9]+)$');

  factory Ingredient.fromString(String source) {
    final match = _regexp.firstMatch(source);
    return Ingredient(
      match.group(1),
      int.parse(match.group(2)),
      int.parse(match.group(3)),
      int.parse(match.group(4)),
      int.parse(match.group(5)),
      int.parse(match.group(6)),
    );
  }

  @override
  List<Object> get props => [name];

  @override
  String toString() => name;
}
