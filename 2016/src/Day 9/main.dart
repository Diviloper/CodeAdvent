import 'dart:io';

void main() {
  first();
  second();
}

void first() {
  String file = File('src/Day 9/input.txt').readAsStringSync();
  final regexp = RegExp(r'(?<before>\w*)(?<marker>\((?<length>\d+)x(?<count>\d+)\))');
  int position = 0;
  RegExpMatch match = regexp.matchAsPrefix(file, position);
  while (match != null) {
    final length = int.parse(match.namedGroup('length'));
    final count = int.parse(match.namedGroup('count'));
    final markerLength = match.namedGroup('marker').length;
    final before = file.substring(0, position) + match.namedGroup('before');
    final compressed = file.substring(before.length + markerLength, before.length + markerLength + length);
    final after = file.substring(before.length + markerLength + length);
    file = before + compressed * count + after;
    position = before.length + compressed.length * count;
    match = regexp.matchAsPrefix(file, position);
  }
  print(file.length);
}

int decompressedLength(String compressedString) {
  int length = 0;
  final regexp = RegExp(r'(?<before>\w*)(?<marker>\((?<length>\d+)x(?<count>\d+)\))');
  int position = 0;
  RegExpMatch match = regexp.matchAsPrefix(compressedString, position);
  while (match != null) {
    final compressedLength = int.parse(match.namedGroup('length'));
    final count = int.parse(match.namedGroup('count'));
    final markerLength = match.namedGroup('marker').length;
    final beforeLength = match.namedGroup('before').length;
    final compressed = compressedString.substring(
        position + beforeLength + markerLength, position + beforeLength + markerLength + compressedLength);
    length += beforeLength + decompressedLength(compressed) * count;
    position += beforeLength + markerLength + compressedLength;
    match = regexp.matchAsPrefix(compressedString, position);
  }
  return length == 0 ? compressedString.length : length;
}

void second() {
  String file = File('src/Day 9/input.txt').readAsStringSync();
  print(decompressedLength(file));
}
