import 'dart:io';

void main() {
  final expressions = File('./input.txt').readAsLinesSync();
  first(expressions);
  second(expressions);
}

void first(List<String> expressions) {
  final sum = expressions.map((e) => e.replaceAll(' ', '')).map(evaluate).reduce((value, element) => value + element);
  print(sum);
}

int evaluate(String expression) {
  final parts = splitExpression(expression);
  if (parts.length == 1) {
    if (parts.single.startsWith('(')) {
      return evaluate(expression.substring(1, expression.length - 1));
    }
    return int.parse(parts.single);
  } else {
    int result = evaluate(parts.first);
    for (int i = 1; i < parts.length;) {
      if (parts[i] == '+') {
        result += evaluate(parts[i + 1]);
      } else if (parts[i] == '*') {
        result *= evaluate(parts[i + 1]);
      }
      i += 2;
    }
    return result;
  }
}

void second(List<String> expressions) {
  final sum =
      expressions.map((e) => e.replaceAll(' ', '')).map(evaluateTree).reduce((value, element) => value + element);
  print(sum);
}

int evaluateTree(String expression) {
  final parts = splitExpression(expression);
  if (parts.length == 1) {
    if (parts.single.startsWith('(')) {
      return evaluateTree(expression.substring(1, expression.length - 1));
    }
    return int.parse(parts.single);
  } else {
    int index = parts.indexOf('+');
    while (index != -1) {
      final result = evaluateTree(parts[index - 1]) + evaluateTree(parts[index + 1]);
      parts.replaceRange(index - 1, index + 2, ['$result']);
      index = parts.indexOf('+');
    }
    index = parts.indexOf('*');
    while (index != -1) {
      final result = evaluateTree(parts[index - 1]) * evaluateTree(parts[index + 1]);
      parts.replaceRange(index - 1, index + 2, ['$result']);
      index = parts.indexOf('*');
    }
    return evaluateTree(parts.join());
  }
}

final numExpression = RegExp(r'^(\d+)');

List<String> splitExpression(String expression) {
  String currentExpression = expression;
  final parts = <String>[];
  while (currentExpression.isNotEmpty) {
    if (numExpression.hasMatch(currentExpression)) {
      final match = numExpression.firstMatch(currentExpression);
      parts..add(match[1]);
      currentExpression = currentExpression.substring(match.end);
    } else if (currentExpression.startsWith('(')) {
      int count = 1;
      int i = 0;
      while (count > 0) {
        ++i;
        if (currentExpression[i] == ')') {
          --count;
        } else if (currentExpression[i] == '(') {
          count++;
        }
      }
      parts..add(currentExpression.substring(0, i + 1));
      currentExpression = currentExpression.substring(i + 1);
    } else {
      parts.add(currentExpression.substring(0, 1));
      currentExpression = currentExpression.substring(1);
    }
  }
  return parts;
}
