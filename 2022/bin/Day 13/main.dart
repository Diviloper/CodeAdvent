import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import '../shared.dart';

class DistressSignal implements Comparable<DistressSignal> {
  final dynamic content;

  DistressSignal(this.content);

  @override
  int compareTo(DistressSignal other) {
    return _compare(content, other.content);
  }

  int _compare(dynamic left, dynamic right) {
    if (left is List && right is List) {
      return _compareList(left, right);
    } else if (left is int && right is int) {
      return left.compareTo(right);
    } else if (left is List) {
      return _compareList(left, [right]);
    } else {
      return _compareList([left], right);
    }
  }

  int _compareList(List left, List right) {
    for (int i = 0; i < min(left.length, right.length); ++i) {
      final result = _compare(left[i], right[i]);
      if (result != 0) {
        return result;
      }
    }
    return left.length.compareTo(right.length);
  }
}

void main() {
  List<Pair<DistressSignal, DistressSignal>> signals = File('input.txt')
      .readAsStringSync()
      .split('\r\n\r\n')
      .map((e) => e.split('\r\n').map(jsonDecode).map(DistressSignal.new))
      .map((e) => Pair(e.first, e.skip(1).first))
      .toList();

  numOrdered(signals);
  decoderKey(signals.expand((e) => [e.first, e.second]).toList());
}

void decoderKey(List<DistressSignal> signals) {
  final d1 = DistressSignal([
    [2]
  ]);
  final d2 = DistressSignal([
    [6]
  ]);
  signals
    ..add(d1)
    ..add(d2);
  signals.sort();
  print((signals.indexOf(d1) + 1) * (signals.indexOf(d2) + 1));
}

void numOrdered(List<Pair<DistressSignal, DistressSignal>> signals) {
  return print(signals
      .map((e) => e.first.compareTo(e.second) == -1)
      .mapIndexed((i, e) => e ? i + 1 : 0)
      .sum);
}
