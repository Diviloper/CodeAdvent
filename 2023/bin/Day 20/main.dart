import 'dart:collection';
import 'dart:io';

import '../common.dart';

sealed class Module {
  final String name;
  final List<String> destinations;
  final List<String> inputs = [];

  Module(this.name, this.destinations);

  List<(String, bool)> processPulse(bool pulse, String from);

  void reset() {}

  void connect(Map<String, Module> modules) {
    inputs.addAll(modules.values
        .where((mod) => mod.destinations.contains(name))
        .map((mod) => mod.name));
  }

  factory Module.fromString(String source) {
    final [id, destinations] = source.split(' -> ');
    final dests = destinations.split(', ');
    switch (id[0]) {
      case '%':
        return FlipFlopModule(id.substring(1), dests);
      case '&':
        return ConjunctionModule(id.substring(1), dests);
      case 'b':
        return BroadcasterModule(id, dests);
      default:
        return NoopModule(id, dests);
    }
  }

  String get state => '$name: $runtimeType';
}

class FlipFlopModule extends Module {
  bool on = false;

  FlipFlopModule(super.name, super.destinations);

  @override
  List<(String, bool)> processPulse(bool pulse, String from) {
    if (pulse) return [];
    on = !on;
    return [for (final dest in destinations) (dest, on)];
  }

  @override
  void reset() {
    on = false;
  }

  @override
  String get state => '$name: $on';

  @override
  String toString() {
    return 'FlipFlopModule{on: $on}';
  }
}

class ConjunctionModule extends Module {
  final Map<String, bool> memory = {};

  ConjunctionModule(super.name, super.destinations);

  @override
  void connect(Map<String, Module> modules) {
    super.connect(modules);
    for (final input in inputs) {
      memory[input] = false;
    }
  }

  @override
  List<(String, bool)> processPulse(bool pulse, String from) {
    memory[from] = pulse;
    final out = !memory.values.every((element) => element);
    return destinations.map((e) => (e, out)).toList();
  }

  @override
  void reset() {
    for (final key in memory.keys) {
      memory[key] = false;
    }
  }

  @override
  String get state => '$name: $memory';

  @override
  String toString() {
    return 'ConjunctionModule{memory: ${memory.values}}';
  }
}

class BroadcasterModule extends Module {
  BroadcasterModule(super.name, super.destinations);

  @override
  List<(String, bool)> processPulse(bool pulse, String from) {
    return destinations.map((e) => (e, pulse)).toList();
  }
}

class NoopModule extends Module {
  NoopModule(super.name, super.destinations);

  @override
  List<(String, bool)> processPulse(bool pulse, String from) {
    return [];
  }
}

void main() {
  final modules = File('./bin/Day 20/input.txt')
      .readAsLinesSync()
      .map(Module.fromString)
      .toMapWithKey((module) => module.name);
  modules.values
      .whereType<ConjunctionModule>()
      .forEach((module) => module.connect(modules));

  print(Iterable.generate(1000)
      .map((_) => pushButton(modules))
      .reduce(
          (value, element) => (value.$1 + element.$1, value.$2 + element.$2))
      .prod);

  for (final element in modules.values) {
    element.reset();
  }

  final inputs = modules['kj']!.inputs;
  final nums = <int>[];
  for (int i = 1; inputs.isNotEmpty; ++i) {
    pushButton(modules);
    for (final input in inputs.copy()) {
      final module = modules[input] as ConjunctionModule;
      if (module.memory.values.any((element) => !element)) {
        inputs.remove(input);
        nums.add(i);
      }
    }
  }
  print(nums.lcm);
}

(int, int) pushButton(
  Map<String, Module> modules, [
  (String, bool)? targetPulse,
]) {
  int lowPulses = 1;
  int highPulses = 0;

  final unprocessedPulses = Queue<(String, String, bool)>();
  unprocessedPulses.add(('', 'broadcaster', false));

  while (unprocessedPulses.isNotEmpty) {
    final (source, destination, pulse) = unprocessedPulses.removeFirst();
    if ((destination, pulse) == targetPulse) {
      throw 'PulseFound';
    }
    if (!modules.containsKey(destination)) continue;
    final newPulses = modules[destination]!.processPulse(pulse, source);
    unprocessedPulses.addAll(newPulses
        .zippedMap((target, newPulse) => (destination, target, newPulse)));
    lowPulses += newPulses.seconds.where((element) => !element).length;
    highPulses += newPulses.seconds.where((element) => element).length;
  }

  return (lowPulses, highPulses);
}
