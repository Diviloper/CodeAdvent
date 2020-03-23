void main() {
  final password = Password('hepxcrrq')..nextValid()..nextValid();
  print(password.password);
}

class Password {
  final List<String> _letters;

  Password(String password) : _letters = password.split('');

  String get password => _letters.join();

  void increase() {
    for (int i = _letters.length - 1; i >= 0; --i) {
      if (_letters[i] != 'z') {
        _letters[i] = String.fromCharCode(_letters[i].codeUnitAt(0) + 1);
        break;
      } else {
        _letters[i] = 'a';
      }
    }
  }

  bool get isValid => hasIncreasingStraight && !containsConfusingLetters && containsTwoPairs;

  bool get hasIncreasingStraight {
    final units = password.codeUnits;
    int current = 0;
    int previous = units.first;
    for (int unit in units) {
      if (unit == previous + 1) {
        ++current;
        if (current == 2) {
          return true;
        }
      } else {
        current = 0;
      }
      previous = unit;
    }
    return false;
  }

  bool get containsConfusingLetters => _letters.toSet().intersection({'i', 'o', 'l'}).isNotEmpty;

  bool get containsTwoPairs => RegExp(r'[a-z]*([a-z])\1[a-z]*([a-z])\2[a-z]*').hasMatch(password);

  void nextValid() {
    increase();
    while (!isValid) {
      increase();
    }
  }
}
