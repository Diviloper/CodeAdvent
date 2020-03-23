import 'dart:io';

class Circuit {
  Set<String> wires = {};
  Map<String, int> wireValues = {};
  Map<String, Gate> wireConnections = {};

  Circuit.fromFile(File input) {
    final connections = input.readAsLinesSync();
    for (final connection in connections) {
      final parts = connection.split(' -> ');
      wires.add(parts.last);
      wireConnections[parts.last] = Gate.fromString(parts.first);
    }
  }

  void simulate() {
    while (wireValues.length < wires.length) {
      for (final connection in wireConnections.entries) {
        if (wireValues[connection.key] == null && connection.value.ready(wireValues)) {
          wireValues[connection.key] = connection.value.output(wireValues);
        }
      }
    }
  }

  void reset() {
    wireValues = {};
  }

  int valueOf(String wire) => wireValues[wire]?.toUnsigned(16);

  void setValueOf(String wire, int value) => wireValues[wire] = value;

  void printValues() {
    print((wireValues.entries.map((entry) => '${entry.key}: ${entry.value.toUnsigned(16)}').toList()
          ..sort())
        .join('\n'));
  }
}

abstract class Gate {
  Gate();

  static final regexValue = RegExp(r'^[0-9a-z]+$');
  static final regexNot = RegExp(r'^NOT\ ([0-9a-z]+)$');
  static final regexAnd = RegExp(r'^([0-9a-z]+)\ AND\ ([0-9a-z]+)$');
  static final regexOr = RegExp(r'^([0-9a-z]+)\ OR\ ([0-9a-z]+)$');
  static final regexLShift = RegExp(r'^([0-9a-z]+)\ LSHIFT\ ([0-9]+)$');
  static final regexRShift = RegExp(r'^([0-9a-z]+)\ RSHIFT\ ([0-9]+)$');

  factory Gate.fromString(String input) {
    if (regexValue.hasMatch(input)) {
      return ValueGate(Signal.fromString(input));
    }
    if (regexNot.hasMatch(input)) {
      return NotGate(Signal.fromString(regexNot.firstMatch(input).group(1)));
    }
    if (regexAnd.hasMatch(input)) {
      final match = regexAnd.firstMatch(input);
      return AndGate(Signal.fromString(match.group(1)), Signal.fromString(match.group(2)));
    }
    if (regexOr.hasMatch(input)) {
      final match = regexOr.firstMatch(input);
      return OrGate(Signal.fromString(match.group(1)), Signal.fromString(match.group(2)));
    }
    if (regexLShift.hasMatch(input)) {
      final match = regexLShift.firstMatch(input);
      return LShiftGate(Signal.fromString(match.group(1)), int.parse(match.group(2)));
    }
    if (regexRShift.hasMatch(input)) {
      final match = regexRShift.firstMatch(input);
      return RShiftGate(Signal.fromString(match.group(1)), int.parse(match.group(2)));
    }
    throw 'Invalid input: $input';
  }

  int output(Map<String, int> wireValues);

  bool ready(Map<String, int> wireValues);
}

class ValueGate extends Gate {
  final Signal input;

  ValueGate(this.input);

  @override
  int output(Map<String, int> wireValues) => input.output(wireValues);

  @override
  bool ready(Map<String, int> wireValues) => input.ready(wireValues);
}

class NotGate extends Gate {
  final Signal input;

  NotGate(this.input);

  @override
  int output(Map<String, int> wireValues) => ~input.output(wireValues);

  @override
  bool ready(Map<String, int> wireValues) => input.ready(wireValues);
}

class AndGate extends Gate {
  final Signal first;
  final Signal second;

  AndGate(this.first, this.second);

  @override
  int output(Map<String, int> wireValues) => first.output(wireValues) & second.output(wireValues);

  @override
  bool ready(Map<String, int> wireValues) => first.ready(wireValues) && second.ready(wireValues);
}

class OrGate extends Gate {
  final Signal first;
  final Signal second;

  OrGate(this.first, this.second);

  @override
  int output(Map<String, int> wireValues) => first.output(wireValues) | second.output(wireValues);

  @override
  bool ready(Map<String, int> wireValues) => first.ready(wireValues) && second.ready(wireValues);
}

class LShiftGate extends Gate {
  final Signal input;
  final int shiftValue;

  LShiftGate(this.input, this.shiftValue);

  @override
  int output(Map<String, int> wireValues) => input.output(wireValues) << shiftValue;

  @override
  bool ready(Map<String, int> wireValues) => input.ready(wireValues);
}

class RShiftGate extends Gate {
  final Signal input;
  final int shiftValue;

  RShiftGate(this.input, this.shiftValue);

  @override
  int output(Map<String, int> wireValues) => input.output(wireValues) >> shiftValue;

  @override
  bool ready(Map<String, int> wireValues) => input.ready(wireValues);
}

abstract class Signal {
  Signal();

  factory Signal.fromString(String input) {
    final parsed = int.tryParse(input);
    if (parsed == null) {
      return Wire(input);
    } else {
      return Value(parsed);
    }
  }

  int output(Map<String, int> wireValues);

  bool ready(Map<String, int> wireValues);
}

class Wire extends Signal {
  final String wire;

  Wire(this.wire);

  @override
  int output(Map<String, int> wireValues) => wireValues[wire];

  @override
  bool ready(Map<String, int> wireValues) => wireValues.containsKey(wire);
}

class Value extends Signal {
  final int value;

  Value(this.value);

  @override
  int output(_) => value;

  @override
  bool ready(_) => true;
}
