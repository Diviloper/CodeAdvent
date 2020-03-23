import 'dart:io';

void main() {
  final input = File('input.txt').readAsLinesSync();
  final sues = input.map((line) => Sue.fromString(line)).toList();
  final target = Sue(null, {
    'children': 3,
    'cats': 7,
    'samoyeds': 2,
    'pomeranians': 3,
    'akitas': 0,
    'vizslas': 0,
    'goldfish': 5,
    'trees': 3,
    'cars': 2,
    'perfumes': 1,
  });
  final sue = sues.singleWhere((sue) => target.match(sue));
  print(sue.index);
  print(sue.compounds);
  print(target.compounds);
}

class Sue {
  final int index;
  final Map<String, int> compounds;

  Sue(this.index, this.compounds);

  static final _lessThan = {'pomeranians', 'goldfish'};
  static final _moreThan = {'cats', 'trees'};

  static final _indexRegexp = RegExp(r'^Sue\ ([0-9]+)');
  static final _compoundRegexp = RegExp(r'([a-z]+):\ ([0-9]+)');

  factory Sue.fromString(String source) {
    final index = int.parse(_indexRegexp.firstMatch(source).group(1));
    final compounds = {
      for (final match in _compoundRegexp.allMatches(source))
        match.group(1): int.parse(match.group(2))
    };
    return Sue(index, compounds);
  }

  bool match(Sue other) =>
      compounds.keys.toSet().intersection(other.compounds.keys.toSet()).every((key) {
        if (_lessThan.contains(key)) {
          return other.compounds[key] < compounds[key];
        } else if (_moreThan.contains(key)) {
          return other.compounds[key] > compounds[key];
        } else {
          return other.compounds[key] == compounds[key];
        }
      });
}
