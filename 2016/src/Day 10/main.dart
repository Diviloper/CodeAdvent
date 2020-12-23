import 'dart:io';

void main() {
  first();
  second();
}

abstract class BotBase {
  void addMicrochip(int microchip);
}

class Bot extends BotBase {
  final int id;
  final String instruction;
  List<int> microchips;

  Bot(this.id, this.instruction);

  @override
  void addMicrochip(int microchip) {
    microchips.add(microchip);
  }

  void giveMicrochips(List<Bot> bots, List<Output> outputs) {
    microchips.sort();
    if (microchips.first == 17) microchips = [];
  }
}

class Output extends BotBase {
  final int id;
  List<int> microchips;

  Output(this.id);

  @override
  void addMicrochip(int microchip) {
    microchips.add(microchip);
  }
}

void first() {
  final instructions = File('src/Day 10/input.txt').readAsLinesSync()..sort();
  
}

void second() {}
