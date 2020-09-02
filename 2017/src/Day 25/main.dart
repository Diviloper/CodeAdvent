void main() {
  first();
  second();
}

typedef State = void Function(TuringMachine);

class Tape {
  final Set<int> _tape = {};

  get ones => _tape.length;

  bool operator [](int index) => _tape.contains(index);

  void operator []=(int index, bool value) {
    if (value) {
      _tape.add(index);
    } else {
      _tape.remove(index);
    }
  }
}

class TuringMachine {
  Tape tape = Tape();
  int cursor = 0;
  String currentState;
  final Map<String, State> states;

  TuringMachine(this.currentState, this.states);

  void step() => states[currentState](this);

  void write(bool value) => tape[cursor] = value;

  bool read() => tape[cursor];

  void moveRight() => ++cursor;

  void moveLeft() => --cursor;

  int get checksum => tape.ones;
}

void first() {
  final int checksumTurns = 12425180;
  final testStates = <String, State>{

    'A': (turing) {
      if (!turing.read()) {
        turing.write(true);
        turing.moveRight();
        turing.currentState = 'B';
      } else {
        turing.write(false);
        turing.moveLeft();
        turing.currentState = 'B';
      }
    },
    'B': (turing) {
      if (!turing.read()) {
        turing.write(true);
        turing.moveLeft();
        turing.currentState = 'A';
      } else {
        turing.write(true);
        turing.moveRight();
        turing.currentState = 'A';
      }
    }
  };
  final states = <String, State>{
    'A': (turing) {
      if (!turing.read()) {
        turing.write(true);
        turing.moveRight();
        turing.currentState = 'B';
      } else {
        turing.write(false);
        turing.moveRight();
        turing.currentState = 'F';
      }
    },
    'B': (turing) {
      if (!turing.read()) {
        turing.write(false);
        turing.moveLeft();
        turing.currentState = 'B';
      } else {
        turing.write(true);
        turing.moveLeft();
        turing.currentState = 'C';
      }
    },
    'C': (turing) {
      if (!turing.read()) {
        turing.write(true);
        turing.moveLeft();
        turing.currentState = 'D';
      } else {
        turing.write(false);
        turing.moveRight();
        turing.currentState = 'C';
      }
    },
    'D': (turing) {
      if (!turing.read()) {
        turing.write(true);
        turing.moveLeft();
        turing.currentState = 'E';
      } else {
        turing.write(true);
        turing.moveRight();
        turing.currentState = 'A';
      }
    },
    'E': (turing) {
      if (!turing.read()) {
        turing.write(true);
        turing.moveLeft();
        turing.currentState = 'F';
      } else {
        turing.write(false);
        turing.moveLeft();
        turing.currentState = 'D';
      }
    },
    'F': (turing) {
      if (!turing.read()) {
        turing.write(true);
        turing.moveRight();
        turing.currentState = 'A';
      } else {
        turing.write(false);
        turing.moveLeft();
        turing.currentState = 'E';
      }
    },
  };
  final turing = TuringMachine('A', states);
  for (int i = 0; i < checksumTurns; ++i) {
    turing.step();
  }
  print(turing.checksum);
}

void second() {}
