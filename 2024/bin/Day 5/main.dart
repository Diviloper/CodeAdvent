import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final [orderLines, updateLines] = File('./input.txt')
      .readAsStringSync()
      .split('${Platform.lineTerminator}${Platform.lineTerminator}');
  final order = getOrders(orderLines.split('\n'));
  final updates = updateLines
      .split('\n')
      .map((line) => line.split(',').map(int.parse).toList())
      .toList();

  final first =
      updates.where((update) => isValid(order, update)).map(getMiddlePage).sum;
  print(first);

  final second = updates
      .where((update) => !isValid(order, update))
      .map((update) => fix(order, update))
      .map(getMiddlePage)
      .sum;
  print(second);
}

Map<int, List<int>> getOrders(List<String> lines) {
  final order = <int, List<int>>{};
  for (final line in lines) {
    final [before, after] = line.split("|").map(int.parse).toList();
    if (!order.containsKey(before)) order[before] = <int>[];
    order[before]!.add(after);
  }
  return order;
}

int getMiddlePage(List<int> update) => update[update.length ~/ 2];

bool isValid(Map<int, List<int>> order, List<int> update) {
  for (int i = 0; i < update.length; ++i) {
    final mustBeAfter = order[update[i]] ?? [];
    for (int j = 0; j < i; ++j) {
      if (mustBeAfter.contains(update[j])) return false;
    }
  }
  return true;
}

List<int> fix(Map<int, List<int>> order, List<int> update) {
  List<int> innerFix(List<int> x) {
    final newUpdate = x.copy();

    for (int i = 0; i < newUpdate.length; ++i) {
      final mustBeAfter = order[newUpdate[i]] ?? [];
      for (int j = 0; j < i; ++j) {
        if (mustBeAfter.contains(newUpdate[j])) {
          newUpdate.insert(j, newUpdate.removeAt(i));
        }
      }
    }
    return newUpdate;
  }

  List<int> fixed = innerFix(update);
  while (!isValid(order, fixed)) {
    fixed = innerFix(fixed);
  }

  return fixed;
}
