import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map(int.parse).toList())
      .toList();
  final cost = {
    for (int i = 0; i < input.length; ++i)
      for (int j = 0; j < input.length; ++j) Tuple(i, j): input[i][j],
  };
  final fullCost = {
    for (int i = 0; i < 5; ++i)
      for (int j = 0; j < 5; ++j)
        for (int k = 0; k < input.length; ++k)
          for (int l = 0; l < input.length; ++l)
            Tuple(input.length * i + k, input.length * j + l):
                (input[k][l] + i + j) >= 10
                    ? (input[k][l] + i + j) - 9
                    : (input[k][l] + i + j),
  };

  findCost(cost, input.length);
  findCost(fullCost, input.length * 5);
}

void findCost(Map<Tuple<int, int>, int> cost, int size) {
  final dist = <Tuple<int, int>, int>{
    for (final tuple in cost.keys) tuple: 999999999,
    Tuple(0, 0): 0
  };
  final q = HeapPriorityQueue<Tuple<Tuple<int, int>, int>>(
      (a, b) => a.second.compareTo(b.second));
  final qSet = {Tuple(0, 0)};
  q.add(Tuple(Tuple(0, 0), 0));
  final prev = <Tuple<int, int>, Tuple<int, int>>{};
  final destination = Tuple(size - 1, size - 1);
  while (q.isNotEmpty) {
    final current = q.removeFirst();
    qSet.remove(current.first);
    if (current.first == destination) break;
    for (final neighbor in current.first.neighbors(size)) {
      final newDist = dist[current.first]! + cost[neighbor]!;
      if (newDist < dist[neighbor]!) {
        dist[neighbor] = newDist;
        prev[neighbor] = current.first;
        q.add(Tuple(neighbor, newDist));
      }
    }
  }
  print(dist[destination]);
}

extension IntTuple on Tuple<int, int> {
  List<Tuple<int, int>> neighbors(int size) => [
        if (first > 0) Tuple(first - 1, second),
        if (second > 0) Tuple(first, second - 1),
        if (second < size - 1) Tuple(first, second + 1),
        if (first < size - 1) Tuple(first + 1, second),
      ];
}
