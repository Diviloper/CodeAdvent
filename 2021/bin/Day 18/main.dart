import 'dart:io';

import 'dart:math';

void main() {
  final nums =
      File('./input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  final result = nums.reduce(add);
  print(magnitude(result));

  int maxMagnitude = 0;
  for (int i = 0; i < nums.length; i++) {
    for (int j = 0; j < nums.length; j++) {
      if (i == j) continue;
      final newMagnitude = magnitude(add(nums[i], nums[j]));
      maxMagnitude = max(newMagnitude, maxMagnitude);
    }
  }
  print(maxMagnitude);
}

int magnitude(List<String> source) {
  String chain = source.join();
  final pairRegexp = RegExp(r'\[(\d+),(\d+)\]');
  while (pairRegexp.hasMatch(chain)) {
    chain = chain.replaceAllMapped(pairRegexp, (match) {
      final left = int.parse(match[1]!);
      final right = int.parse(match[2]!);
      return '${3 * left + 2 * right}';
    });
  }
  return int.parse(chain);
}

List<String> add(List<String> first, List<String> second) {
  final result = ['[', ...first, ',', ...second, ']'];
  while (explode(result) || split(result)) {}
  return result;
}

bool explode(List<String> source) {
  int level = 0;
  int start;
  for (start = 0; start < source.length; ++start) {
    if (source[start] == '[') {
      ++level;
    } else if (source[start] == ']') {
      --level;
    }
    if (level == 5) break;
  }
  if (start == source.length) {
    return false;
  }
  final end = source.indexOf(']', start);
  assert(start + 4 == end);
  final left = int.parse(source[start + 1]);
  final right = int.parse(source[start + 3]);

  final nextIndex =
      source.indexWhere((element) => int.tryParse(element) != null, end);
  if (nextIndex > 0) {
    source[nextIndex] = '${int.parse(source[nextIndex]) + right}';
  }
  int previousIndex = start;
  for (int i = 0; i < start; ++i) {
    if (int.tryParse(source[i]) != null) {
      previousIndex = i;
    }
  }
  if (previousIndex < start) {
    source[previousIndex] = '${int.parse(source[previousIndex]) + left}';
  }
  source.replaceRange(start, end + 1, ['0']);
  return true;
}

bool split(List<String> source) {
  final index =
      source.indexWhere((element) => (int.tryParse(element) ?? 0) >= 10);
  if (index >= 0) {
    final value = int.parse(source[index]) / 2;
    source.replaceRange(index, index + 1, [
      '[',
      '${value.floor()}',
      ',',
      '${value.ceil()}',
      ']',
    ]);
    return true;
  }
  return false;
}

class SnailfishNumber {
  dynamic left;
  dynamic right;

  SnailfishNumber(this.left, this.right)
      : assert(left is int || left is SnailfishNumber),
        assert(right is int || right is SnailfishNumber);

  SnailfishNumber operator +(SnailfishNumber other) =>
      SnailfishNumber(this, other);

  bool get isRegular => left is int && right is int;

  bool split() {
    if (left.canSplit) {
      if (left is int) {
        left = (left as int).split();
        return true;
      } else {
        return left.split();
      }
    }
    if (right.canSplit) {
      if (right is int) {
        right = (right as int).split();
        return true;
      } else {
        return right.split();
      }
    }
    return false;
  }

  bool get canSplit => _canSplitLeft || _canSplitRight;

  bool get _canSplitLeft => left.canSplit;

  bool get _canSplitRight => right.canSplit;

  @override
  String toString() => '[$left,$right]';
}

extension SnailInt on int {
  bool get canSplit => this >= 10;

  SnailfishNumber split() =>
      SnailfishNumber((this / 2).floor(), (this / 2).ceil());

  int get magnitude => this;
}
