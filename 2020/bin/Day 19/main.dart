import 'dart:io';

extension on Set<String> {
  Set<String> operator *(Set<String> other) => {for (final first in this) for (final second in other) first + second};
}

abstract class Rule {
  Set<String> get matches;

  Rule();

  static final _matchRuleRegexp = RegExp(r'^"(\w)"$');
  static final _sequenceRuleRegexp = RegExp(r'^\d+(?: \d+)*$');
  static final _orRuleRegexp = RegExp(r'^\d+(?: \d+)* \| \d+(?: \d+)*$');

  factory Rule.build(String name, Map<String, String> ruleSources, Map<String, Rule> ruleMemory) {
    if (ruleMemory.containsKey(name)) return ruleMemory[name];
    final source = ruleSources[name];
    RegExpMatch match = _matchRuleRegexp.firstMatch(source);
    if (match != null) {
      return ruleMemory[name] = MatchRule(match[1]);
    }
    match = _sequenceRuleRegexp.firstMatch(source);
    if (match != null) {
      return ruleMemory[name] =
          SequenceRule(source.split(' ').map((e) => Rule.build(e, ruleSources, ruleMemory)).toList());
    }
    match = _orRuleRegexp.firstMatch(source);
    if (match != null) {
      final options = source
          .split(' | ')
          .map((option) => SequenceRule(option.split(' ').map((e) => Rule.build(e, ruleSources, ruleMemory)).toList()))
          .toList();
      return ruleMemory[name] = OrRule(options);
    }
    throw Exception('Unable to build rule');
  }
}

class MatchRule extends Rule {
  final String _matcher;

  MatchRule(this._matcher);

  @override
  Set<String> get matches => {_matcher};
}

class SequenceRule extends Rule {
  final List<Rule> _subRules;

  SequenceRule(this._subRules);

  @override
  Set<String> get matches => _subRules.map((e) => e.matches).reduce((value, element) => value * element);
}

class OrRule extends Rule {
  final List<Rule> _subRules;

  OrRule(this._subRules);

  @override
  Set<String> get matches => _subRules.map((e) => e.matches).reduce((value, element) => value.union(element));
}

void main() {
  final input = File('./input.txt').readAsStringSync().split('\r\n\r\n');
  final rules = input.first.split('\r\n');
  final messages = input.last.split('\r\n');
  first(rules, messages);
}

void first(List<String> rules, List<String> messages) {
  final ruleMap = {for (final rule in rules) rule.split(': ').first: rule.split(': ').last};
  final rule = Rule.build('0', ruleMap, {});
  print(rule.matches.intersection(messages.toSet()).length);
}
