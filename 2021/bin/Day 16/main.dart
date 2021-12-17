import 'dart:io';
import 'dart:math';

import '../common.dart';

void main() {
  final binary = File('./input.txt')
      .readAsStringSync()
      .split('')
      .map(Hex.parse)
      .map((e) => e.toRadixString(2).padLeft(4, '0'))
      .join();
  final packet = Packet.hierarchyFromString(binary);
  print(packet.versionSum);
  print(packet.value);
}

abstract class Packet {
  final int versionNumber;
  final int type;

  int get versionSum => versionNumber;

  int get value;

  Packet(this.versionNumber, this.type);

  factory Packet.hierarchyFromString(String source) {
    return _createPacket(source.split(''), 0).first;
  }

  static Tuple<Packet, int> _createPacket(List<String> binary, int index) {
    final version =
        int.parse(binary.sublist(index, index + 3).join(), radix: 2);
    final type =
        int.parse(binary.sublist(index + 3, index + 6).join(), radix: 2);
    index += 6;
    if (type == 4) {
      String value = '';
      do {
        value += binary.sublist(index + 1, index + 5).join();
        index += 5;
      } while (binary[index - 5] != '0');
      return Tuple(LiteralPacket(version, int.parse(value, radix: 2)), index);
    } else {
      final lengthType = binary[index++];
      if (lengthType == '0') {
        final totalLength =
            int.parse(binary.sublist(index, index + 15).join(), radix: 2);
        index += 15;
        final lastIndex = index + totalLength;
        final subpackets = <Packet>[];
        while (index < lastIndex) {
          final newPacket = _createPacket(binary, index);
          subpackets.add(newPacket.first);
          index = newPacket.second;
        }
        return Tuple(OperatorPacket(version, type, subpackets), index);
      } else {
        final numberOfSubpackets =
            int.parse(binary.sublist(index, index + 11).join(), radix: 2);
        index += 11;
        final subpackets = <Packet>[];
        for (int i = 0; i < numberOfSubpackets; ++i) {
          final newPacket = _createPacket(binary, index);
          subpackets.add(newPacket.first);
          index = newPacket.second;
        }
        return Tuple(OperatorPacket(version, type, subpackets), index);
      }
    }
  }
}

class LiteralPacket extends Packet {
  @override
  final int value;

  LiteralPacket(int versionNumber, this.value) : super(versionNumber, 4);

  @override
  String toString() => '[$value]';
}

class OperatorPacket extends Packet {
  final List<Packet> subpackets;

  final int Function(int, int) operator;

  @override
  int get value => subpackets.map((e) => e.value).reduce(operator);

  @override
  int get versionSum =>
      versionNumber +
      subpackets
          .map((e) => e.versionSum)
          .reduce((value, element) => value + element);

  OperatorPacket._(int versionNumber, int type, this.subpackets, this.operator)
      : super(versionNumber, type);

  factory OperatorPacket(int versionNumber, int type, List<Packet> subpackets) {
    int Function(int, int) operator;
    switch (type) {
      case 0:
        operator = (a, b) => a + b;
        break;
      case 1:
        operator = (a, b) => a * b;
        break;
      case 2:
        operator = (a, b) => min(a, b);
        break;
      case 3:
        operator = (a, b) => max(a, b);
        break;
      case 5:
        operator = (a, b) => a > b ? 1 : 0;
        break;
      case 6:
        operator = (a, b) => a < b ? 1 : 0;
        break;
      case 7:
        operator = (a, b) => a == b ? 1 : 0;
        break;
      default:
        throw 'Invalid version';
    }
    return OperatorPacket._(versionNumber, type, subpackets, operator);
  }

  @override
  String toString() => '[op[${subpackets.join()}]]';
}
