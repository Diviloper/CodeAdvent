import 'dart:math';

import 'package:trotter/trotter.dart';

void main() {
  final boss = Player(103, 2, 9);
  final player = Player(100, 0, 0);
  print(Player.wins(player, boss));
  final weapons = {
    8: (Player player) => player.damage += 4,
    10: (Player player) => player.damage += 5,
    25: (Player player) => player.damage += 6,
    40: (Player player) => player.damage += 7,
    74: (Player player) => player.damage += 8,
  };
  final armors = {
    13: (Player player) => player.armor += 1,
    31: (Player player) => player.armor += 2,
    53: (Player player) => player.armor += 3,
    75: (Player player) => player.armor += 4,
    102: (Player player) => player.armor += 5,
  };
  final rings = {
    25: (Player player) => player.damage += 1,
    50: (Player player) => player.damage += 2,
    100: (Player player) => player.damage += 3,
    20: (Player player) => player.armor += 1,
    40: (Player player) => player.armor += 2,
    80: (Player player) => player.armor += 3,
  };
  print(getMinGoldToWin(weapons, armors, rings, player, boss));
  print(getMaxGoldToLose(weapons, armors, rings, player, boss));
}

int getMinGoldToWin(
  Map<int, int Function(Player)> weapons,
  Map<int, int Function(Player)> armors,
  Map<int, int Function(Player)> rings,
  Player player,
  Player enemy,
) {
  int minGold = 999999999;
  final weaponPossibilities = Subsets(weapons.keys.toList())().where((e) => e.length == 1);
  final armorPossibilities = Subsets(armors.keys.toList())().where((e) => e.length <= 1);
  final ringPossibilities = Subsets(rings.keys.toList())().where((e) => e.length <= 2);
  for (final weapon in weaponPossibilities) {
    for (final armor in armorPossibilities) {
      for (final ring in ringPossibilities) {
        final cost = sum(weapon.followedBy(armor).followedBy(ring));
        if (cost > minGold) {
          continue;
        }
        player.resetValues();
        for (final w in weapon) {
          weapons[w](player);
        }
        for (final a in armor) {
          armors[a](player);
        }
        for (final r in ring) {
          rings[r](player);
        }
        if (Player.wins(player, enemy)) {
          minGold = cost;
        }
      }
    }
  }
  return minGold;
}

int getMaxGoldToLose(
  Map<int, int Function(Player)> weapons,
  Map<int, int Function(Player)> armors,
  Map<int, int Function(Player)> rings,
  Player player,
  Player enemy,
) {
  int maxGold = 0;
  final weaponPossibilities = Subsets(weapons.keys.toList())().where((e) => e.length == 1);
  final armorPossibilities = Subsets(armors.keys.toList())().where((e) => e.length <= 1);
  final ringPossibilities = Subsets(rings.keys.toList())().where((e) => e.length <= 2);
  for (final weapon in weaponPossibilities) {
    for (final armor in armorPossibilities) {
      for (final ring in ringPossibilities) {
        final cost = sum(weapon.followedBy(armor).followedBy(ring));
        if (cost < maxGold) {
          continue;
        }
        player.resetValues();
        for (final w in weapon) {
          weapons[w](player);
        }
        for (final a in armor) {
          armors[a](player);
        }
        for (final r in ring) {
          rings[r](player);
        }
        if (!Player.wins(player, enemy)) {
          maxGold = cost;
        }
      }
    }
  }
  return maxGold;
}

int sum(Iterable<int> it) => it.fold<int>(0, (a, b) => a + b);

class Player {
  final int maxHealth;
  final int initArmor;
  final int initDamage;

  int health;
  int armor;
  int damage;

  Player(this.maxHealth, this.initArmor, this.initDamage)
      : health = maxHealth,
        armor = initArmor,
        damage = initDamage;

  void respawn() {
    health = maxHealth;
  }

  void resetValues() {
    health = maxHealth;
    armor = initArmor;
    damage = initDamage;
  }

  void attack(Player other) {
    other.health -= max(1, damage - other.armor);
  }

  bool get isDead => health <= 0;

  bool get isAlive => health > 0;

  static bool wins(Player first, Player second) {
    bool turn = true;
    while (first.isAlive && second.isAlive) {
      if (turn) {
        first.attack(second);
      } else {
        second.attack(first);
      }
      turn = !turn;
    }
    final result = first.isAlive;
    first.respawn();
    second.respawn();
    return result;
  }
}
