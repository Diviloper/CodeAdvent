import 'dart:convert';
import 'dart:io';

void main() {
  final input = File('input.json').readAsStringSync();
  final regexp = RegExp(r'\-?[0-9]+');
  final matches = regexp.allMatches(input);
  int sum = matches.map((match) => int.parse(match.group(0))).reduce((a, b) => a + b);
  print(sum);
  final decoded = jsonDecode(input) as List;
  sum = sumExceptRedList(decoded);
  print(sum);
}

int sumExceptRedList(List decoded) {
  int sum = 0;
  for (final element in decoded) {
    if (element is List) {
      sum += sumExceptRedList(element);
    } else if (element is Map) {
      sum += sumExceptRedMap(element);
    } else if (element is int) {
      sum += element;
    }
  }
  return sum;
}

int sumExceptRedMap(Map decoded) {
  if (decoded.values.contains('red')) {
    return 0;
  }
  int sum = 0;
  for (final element in decoded.values) {
    if (element is List) {
      sum += sumExceptRedList(element);
    } else if (element is Map) {
      sum += sumExceptRedMap(element);
    } else if (element is int) {
      sum += element;
    }
  }
  return sum;
}
