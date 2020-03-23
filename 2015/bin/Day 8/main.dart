import 'dart:io';

void main() {
  final input = File('input.txt').readAsLinesSync();
  final sizes = input.map((line) => line.length).toList();
  final memorySizes = input
      .map((line) => line
          .substring(1, line.length - 1)
          .replaceAll(RegExp(r'(\\x[0-9a-f]{2})|(\\\\)|(\\")'), ' ')
          .length)
      .toList();
  final encodedSizes = input
      .map((line) => line
          .replaceAllMapped(RegExp(r'(\\\\)|(\\")'), (match) => ' ${match.group(0)} ')
          .replaceAllMapped(RegExp(r'(\\x[0-9a-f]{2})'), (match) => ' ${match.group(0)}')
          .length + 4)
      .toList();
  int add(int a, int b) => a + b;
  print(sizes.reduce(add) - memorySizes.reduce(add));
  print(encodedSizes.reduce(add) - sizes.reduce(add));
}
