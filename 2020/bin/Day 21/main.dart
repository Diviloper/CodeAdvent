import 'dart:io';

class Food {
  final Set<String> ingredients;
  final Set<String> allergens;

  Food(this.ingredients, this.allergens);

  factory Food.fromString(String source) {
    final parts = source.split(' (contains ');
    final ingredients = parts.first.split(' ').toSet();
    final allergens = parts.last.substring(0, parts.last.length - 1).split(', ').toSet();
    return Food(ingredients, allergens);
  }

  bool containsIngredient(String ingredient) => ingredients.contains(ingredient);

  bool containsAllergen(String allergen) => allergens.contains(allergen);
}

void main() {
  final foods = File('./input.txt').readAsLinesSync().map((e) => Food.fromString(e)).toList();
  first(foods);
  second(foods);
}

void first(List<Food> foods) {
  final allergens = foods.map((e) => e.allergens).reduce((value, element) => value.union(element));
  final allergenMap = <String, String>{};
  final allergenIngredients = <String>{};
  while (allergenMap.length != allergens.length) {
    for (final allergen in allergens) {
      final ingredients = foods
          .where((food) => food.containsAllergen(allergen))
          .map((food) => food.ingredients)
          .reduce((value, element) => value.intersection(element))
          .difference(allergenIngredients);
      if (ingredients.length == 1) {
        allergenMap[allergen] = ingredients.single;
        allergenIngredients.add(ingredients.single);
      }
    }
  }
  final nonAllergicIngredients =
      foods.map((e) => e.ingredients).reduce((value, element) => value.union(element)).difference(allergenIngredients);
  int count = 0;
  for (final ingredient in nonAllergicIngredients) {
    for (final food in foods) {
      if (food.containsIngredient(ingredient)) {
        ++count;
      }
    }
  }
  print(count);
}

void second(List<Food> foods) {
  final allergens = foods.map((e) => e.allergens).reduce((value, element) => value.union(element));
  final allergenMap = <String, String>{};
  final allergenIngredients = <String>{};
  while (allergenMap.length != allergens.length) {
    for (final allergen in allergens) {
      final ingredients = foods
          .where((food) => food.containsAllergen(allergen))
          .map((food) => food.ingredients)
          .reduce((value, element) => value.intersection(element))
          .difference(allergenIngredients);
      if (ingredients.length == 1) {
        allergenMap[ingredients.single] = allergen;
        allergenIngredients.add(ingredients.single);
      }
    }
  }
  print((allergenIngredients.toList()..sort((a, b) => allergenMap[a].compareTo(allergenMap[b]))).join(','));
}
