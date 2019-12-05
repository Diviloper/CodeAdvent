import 'dart:io';
void main() => print(File("input.txt").readAsLinesSync().map((v) => int.parse(v)).reduce((curr, value) => curr + value));