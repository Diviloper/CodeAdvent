import 'dart:io';

void main() {
  first();
  second();
}

void first() {
  final ips = File('src/Day 7/input.txt').readAsLinesSync();
  final invalidAbba = RegExp(r'\[\w*(\w)(?!\1)(\w)\2\1\w*\]');
  final abba = RegExp(r'(\w)(?!\1)(\w)\2\1');
  int count = 0;
  for (final ip in ips) {
    if (!invalidAbba.hasMatch(ip) && abba.hasMatch(ip)) ++count;
  }
  print(count);
}

void second() {
  final ips = File('src/Day 7/input.txt').readAsLinesSync();
  final hypernet = RegExp(r'\[\w*\]');
  final aba = RegExp(r'(?<a>\w)(?!\1)(?=(?<b>\w)\1)');
  int count = 0;
  for (final ip in ips) {
    final hypernetSequences = hypernet.allMatches(ip).map((e) => e[0]).join();
    final supernetSequences = ip.replaceAll(hypernet, '-');
    final abas = aba.allMatches(supernetSequences);
    for (final match in abas) {
      final bab = '${match.namedGroup('b')}${match.namedGroup('a')}${match.namedGroup('b')}';
      if (hypernetSequences.contains(bab)) {
        ++count;
        break;
      }
    }
  }
  print(count);
}
