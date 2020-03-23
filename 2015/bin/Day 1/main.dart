import 'dart:io';

void main() {
  final input = File('input.txt').readAsStringSync().split('');
  int current = 0;
  int i=0;
  for (i=0; i<input.length; ++i) {
    current += (input[i] == '(' ? 1 : -1);
    if (current == -1) {
      break;
    }
  }
  print(i+1);
}
