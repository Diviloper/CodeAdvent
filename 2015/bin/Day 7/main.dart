import 'dart:io';

import '../Shared/circuit.dart';

void main() {
  final circuit = Circuit.fromFile(File('input.txt'));
  circuit.simulate();
  final value = circuit.valueOf('a');
  circuit.reset();
  circuit.setValueOf('b', value);
  circuit.simulate();
  print(circuit.valueOf('a'));
}
