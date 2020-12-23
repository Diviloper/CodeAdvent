import 'dart:io';

void main() {
  first();
  second();
}

class Room {
  final String code;
  final int sectionID;
  final String checksum;

  Room(this.code, this.sectionID, this.checksum);

  factory Room.fromString(String roomLine) {
    final regexp = RegExp(r'(?<code>[a-z\-]+)\-(?<sectionID>\d+)\[(?<checksum>[a-z]{5})\]');
    final match = regexp.firstMatch(roomLine);
    return Room(match.namedGroup('code'), int.parse(match.namedGroup('sectionID')), match.namedGroup('checksum'));
  }

  bool isReal() {
    Map<String, int> occurrences = {};
    for (final letter in code.replaceAll('-', '').split('')) {
      occurrences.update(letter, (value) => value + 1, ifAbsent: () => 1);
    }
    int comparator(String a, String b) {
      final value = occurrences[b].compareTo(occurrences[a]);
      if (value == 0) return a.compareTo(b);
      return value;
    }

    return checksum == (occurrences.keys.toList()..sort(comparator)).take(5).join();
  }

  String get decryptedName {
    return code
        .split('-')
        .map((e) => e
            .split('')
            .map((e) => String.fromCharCode(
                ((e.codeUnitAt(0) - 'a'.codeUnitAt(0) + sectionID) % ('z'.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1)) +
                    'a'.codeUnitAt(0)))
            .join())
        .join(' ');
  }
}

void first() {
  final rooms = File('src/Day 4/input.txt').readAsLinesSync().map((e) => Room.fromString(e)).toList();
  print(rooms.where((room) => room.isReal()).fold<int>(0, (acc, room) => acc + room.sectionID));
}

void second() {
  final rooms = File('src/Day 4/input.txt').readAsLinesSync().map((e) => Room.fromString(e)).toList();
  print(rooms.firstWhere((room) => room.decryptedName == 'northpole object storage').sectionID);
}
