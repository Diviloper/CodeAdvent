import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

import '../common.dart';

class Part {
  final int x;
  final int m;
  final int a;
  final int s;

  Part(this.x, this.m, this.a, this.s);

  factory Part.fromString(String source) {
    final re = RegExp(r'\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}');
    final match = re.firstMatch(source)!;
    return Part(int.parse(match[1]!), int.parse(match[2]!),
        int.parse(match[3]!), int.parse(match[4]!));
  }

  int operator [](String source) => switch (source) {
        'x' => x,
        'm' => m,
        'a' => a,
        's' => s,
        _ => throw ArgumentError.value(s)
      };

  int get sum => x + m + a + s;
}

typedef Rule = bool Function(Part);
typedef RuleSource = (String, String, int);

RuleSource negate(RuleSource rule) {
  if (rule.$2 == '>') {
    return (rule.$1, '<', rule.$3 + 1);
  } else {
    return (rule.$1, '>', rule.$3 - 1);
  }
}

class Workflow {
  final String id;
  final List<(Rule, String)> rules;
  final List<(RuleSource, String)> ruleSources;
  final String end;

  Workflow(this.id, this.rules, this.ruleSources, this.end);

  String execute(Part part) {
    for (final (rule, destination) in rules) {
      if (rule(part)) return destination;
    }
    return end;
  }

  factory Workflow.fromString(String source) {
    final [id, rest] = source.split('{');
    final sourceRules = rest.replaceAll('}', '').split(',');
    final end = sourceRules.removeLast();
    final rules = <(Rule, String)>[];
    final ruleSources = <(RuleSource, String)>[];
    for (final ruleSource in sourceRules) {
      final [condition, dest] = ruleSource.split(':');
      final attribute = condition[0];
      final comparison = condition[1];
      final value = int.parse(condition.substring(2));
      final conditionFunction = comparison == '<'
          ? (Part part) => part[attribute] < value
          : (Part part) => part[attribute] > value;
      rules.add((conditionFunction, dest));
      ruleSources.add(((attribute, comparison, value), dest));
    }
    return Workflow(id, rules, ruleSources, end);
  }
}

void main() {
  final [worklowInput, partInput] =
      File('./bin/Day 19/input.txt').readAsStringSync().split('\n\n');
  final workflows = worklowInput
      .split('\n')
      .map(Workflow.fromString)
      .toMap((part) => part.id);
  final parts = partInput.split('\n').map(Part.fromString).toList();

  print(parts.where((part) => accepted(part, workflows)).map((p) => p.sum).sum);

  print(getAcceptingPaths(workflows).map(getAcceptedCombinations).sum);
}

bool accepted(Part part, Map<String, Workflow> workflows) {
  String workflowID = 'in';
  while (workflowID != 'R' && workflowID != 'A') {
    workflowID = workflows[workflowID]!.execute(part);
  }
  return workflowID == 'A';
}

List<List<RuleSource>> getAcceptingPaths(Map<String, Workflow> workflows) {
  final acceptingPaths = <List<RuleSource>>[];
  final currentPaths = Queue<(List<RuleSource>, String)>();
  currentPaths.add(([], 'in'));
  while (currentPaths.isNotEmpty) {
    final (currentPath, currentWorkflowId) = currentPaths.removeFirst();
    final currentWorkflow = workflows[currentWorkflowId]!;
    for (final (ruleSource, destination) in currentWorkflow.ruleSources) {
      if (destination == 'A') {
        acceptingPaths.add(currentPath + [ruleSource]);
      } else if (destination != 'R') {
        currentPaths.add((currentPath + [ruleSource], destination));
      }
      currentPath.add(negate(ruleSource));
    }
    if (currentWorkflow.end == 'A') {
      acceptingPaths.add(currentPath);
    } else if (currentWorkflow.end != 'R') {
      currentPaths.add((currentPath, currentWorkflow.end));
    }
  }
  return acceptingPaths;
}

int getAcceptedCombinations(List<RuleSource> path) {
  final values = [
    [0, 4001],
    [0, 4001],
    [0, 4001],
    [0, 4001],
  ];

  for (final (attribute, condition, value) in path) {
    final index = switch (attribute) {
      'x' => 0,
      'm' => 1,
      'a' => 2,
      's' => 3,
      _ => -1,
    };
    if (condition == '>') {
      values[index][0] = max(values[index][0], value);
    } else {
      values[index][1] = min(values[index][1], value);
    }
  }
  if (values.any((values) => values.last < values.first)) return 0;
  return values.map((e) => e.last - e.first - 1).prod;
}
