import 'dart:io';

import 'package:equatable/equatable.dart';

extension MergeableMap<K, V> on Map<K, V> {
  void merge(Map<K, V> other, V Function(V, V) mergeFunction) {
    other.forEach((key, value) {
      this.update(
        key,
        (val) => mergeFunction(val, value),
        ifAbsent: () => value,
      );
    });
  }
}

class Component with EquatableMixin {
  final String name;
  final Reaction recipe;
  final List<Reaction> ingredient = [];
  int level;

  Component(this.name, this.recipe);

  void updateLevel(Map<String, Component> components) {
    if (name == 'ORE')
      level = 0;
    else {
      int maxLevel = 0;
      for (var value in recipe.ingredients.keys) {
        components[value].updateLevel(components);
        maxLevel = maxLevel > components[value].level
            ? maxLevel
            : components[value].level;
      }
      level = maxLevel + 1;
    }
  }

  @override
  List<Object> get props => [name];
}

class Reaction {
  String recipe;
  MapEntry<String, int> output;
  Map<String, int> ingredients;

  String get outputComponent => output.key;

  int get outputQuantity => output.value;

  Reaction.fromString(this.recipe) {
    final inOut = recipe.split(' => ');
    output = _componentFromString(inOut[1]);
    ingredients =
        Map.fromEntries(inOut[0].split(', ').map(_componentFromString));
  }

  MapEntry<String, int> _componentFromString(String compString) {
    final split = compString.split(' ');
    return MapEntry(split[1], int.parse(split[0]));
  }

  @override
  String toString() => recipe;
}

void main() {
  final recipes = File("input.txt")
      .readAsLinesSync()
      .map((recipe) => Reaction.fromString(recipe))
      .toList();
  Set<String> names = {
    for (var recipe in recipes) ...[
      recipe.outputComponent,
      ...recipe.ingredients.keys
    ]
  };
  Map<String, Component> components = Map.fromIterable(
    names,
    value: (name) => Component(
      name,
      recipes.firstWhere(
        (recipe) => recipe.outputComponent == name,
        orElse: () => null,
      ),
    ),
  );
  for (var recipe in recipes) {
    for (var ingredient in recipe.ingredients.keys) {
      components[ingredient].ingredient.add(recipe);
    }
  }
  components['FUEL'].updateLevel(components);
  Map<String, int> necessities = {"FUEL": 1};
  int necessaryOre = calculateNecessaryOre(components, necessities);
  print("Necessary ORE: $necessaryOre");
}

int calculateNecessaryOre(
  Map<String, Component> components,
  Map<String, int> necessities,
) {
  if (necessities.length == 1 && necessities.keys.first == 'ORE')
    return necessities['ORE'];
  int minOre = null;
  final sortedKeys = necessities.keys.toList()
    ..sort(
      (nameA, nameB) =>
          -components[nameA].level.compareTo(components[nameB].level),
    );
  final componentName = sortedKeys.first;
  final Component component = components[componentName];
  final recipe = component.recipe;
  final times = (necessities[componentName] / recipe.outputQuantity).ceil();
  final newNecessities = Map<String, int>.from(necessities);
  newNecessities[componentName] -= recipe.outputQuantity * times;
  if (newNecessities[componentName] <= 0) {
    newNecessities.remove(componentName);
  }
  newNecessities.merge(
    Map.from(recipe.ingredients)..updateAll((key, value) => value * times),
    (a, b) => a + b,
  );
  final int newOre = calculateNecessaryOre(components, newNecessities);
  minOre = minOre == null ? newOre : minOre < newOre ? minOre : newOre;
  return minOre;
}
