import 'dart:io';

class Range {
  final int start;
  final int end;

  Range(this.start, this.end);

  Range.fromString(String from) : this(int.parse(from.split('-').first), int.parse(from.split('-').last));

  bool valid(int value) => start <= value && value <= end;

  @override
  String toString() => '[$start,$end]';
}

void main() {
  final parts = File('./input.txt').readAsStringSync().split('\r\n\r\n');
  final ruleRegexp = RegExp(r'^([\w ]+): (\d+\-\d+) or (\d+\-\d+)$');
  final validationRules = {
    for (final match in parts[0].split('\r\n').map(ruleRegexp.firstMatch))
      match[1]: [Range.fromString(match[2]), Range.fromString(match[3])],
  };
  final ticket = parts[1].split('\r\n').last.split(',').map(int.parse).toList();
  final tickets = parts[2].split('\r\n').skip(1).map((t) => t.split(',').map(int.parse).toList()).toList();
  first(validationRules, tickets);
  second(validationRules, tickets, ticket);
}

void first(Map<String, List<Range>> validationRules, List<List<int>> tickets) {
  int count = 0;
  final rules = validationRules.values.expand((element) => element).toList();
  for (final ticket in tickets) {
    for (final field in ticket) {
      if (!rules.any((element) => element.valid(field))) count += field;
    }
  }
  print(count);
}

bool isValid(List<int> ticket, List<Range> validationRules) {
  for (final field in ticket) {
    if (validationRules.every((rule) => !rule.valid(field))) return false;
  }
  return true;
}

bool isFieldValid(int field, List<Range> validationRules) => validationRules.any((rule) => rule.valid(field));

void second(Map<String, List<Range>> validationRules, List<List<int>> tickets, List<int> ownTicket) {
  final rules = validationRules.values.expand((element) => element).toList();
  final validTickets = tickets.where((ticket) => isValid(ticket, rules)).toList()..add(ownTicket);
  final fieldPossibilities = <String, List<int>>{
    for (final field in validationRules.keys)
      field: [],
  };
  for (int i = 0; i < ownTicket.length; ++i) {
    for (final field in validationRules.keys) {
      if (validTickets.every((ticket) => isFieldValid(ticket[i], validationRules[field]))) {
        fieldPossibilities[field].add(i);
      }
    }
  }

  final fieldMap = <String, int>{};
  while (fieldMap.length != fieldPossibilities.length) {
    for (final key in fieldPossibilities.keys) {
      if (fieldPossibilities[key].length == 1) {
        fieldMap[key] = fieldPossibilities[key].single;
        fieldPossibilities.updateAll((_, value) => value..remove(fieldMap[key]));
      }
    }
  }

  int count = fieldPossibilities.keys
      .where((element) => element.startsWith('departure'))
      .map((e) => ownTicket[fieldMap[e]])
      .reduce((value, element) => value * element);
  print(count);
}
