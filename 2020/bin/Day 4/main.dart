import 'dart:io';

class Passport {
  final data = <String, String>{};

  static const requiredKeys = {
    'byr',
    'iyr',
    'eyr',
    'hgt',
    'hcl',
    'ecl',
    'pid',
    // 'cid',
  };

  static final validators = <String, bool Function(String)>{
    'byr': (value) => int.parse(value) >= 1920 && int.parse(value) <= 2002,
    'iyr': (value) => int.parse(value) >= 2010 && int.parse(value) <= 2020,
    'eyr': (value) => int.parse(value) >= 2020 && int.parse(value) <= 2030,
    'hgt': (value) {
      final match = RegExp(r'^(\d+)((?:cm)|(?:in))$').matchAsPrefix(value);
      if (match == null) return false;
      final height = int.parse(match[1]);
      final unit = match[2];
      switch (unit) {
        case 'cm':
          return height >= 150 && height <= 193;
        case 'in':
          return height >= 59 && height <= 76;
        default:
          return false;
      }
    },
    'hcl': RegExp(r'^#[a-f0-9]{6}$').hasMatch,
    'ecl': {'amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'}.contains,
    'pid': RegExp(r'^\d{9}$').hasMatch,
    'cid': (_) => true,
  };

  static final _keysRegexp = RegExp(r'(\w{3}):(\S*)');

  Passport(List<String> lines) {
    for (final line in lines) {
      for (final match in _keysRegexp.allMatches(line)) {
        data[match[1]] = match[2];
      }
    }
  }

  bool get hasAllKeys => data.keys.toSet().containsAll(requiredKeys);

  bool get isValid =>
      hasAllKeys &&
      data.entries.every((element) => validators[element.key](element.value));
}

void main() {
  final lines = File('./input.txt').readAsLinesSync();
  final passports = <Passport>[];
  int last = 0;
  for (int current = 0; current < lines.length; ++current) {
    if (lines[current] == '') {
      passports.add(Passport(lines.sublist(last, current)));
      last = current + 1;
    }
  }
  print(passports.where((element) => element.hasAllKeys).length);
  print(passports.where((element) => element.isValid).length);
}
