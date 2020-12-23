import 'dart:io';
import 'dart:collection';

void main() {
  final cards = File('./input.txt')
      .readAsStringSync()
      .split('\r\n\r\n')
      .map((e) => e.split('\r\n').skip(1).map(int.parse).toList())
      .toList();
  final player1 = Queue.of(cards.first);
  final player2 = Queue.of(cards.last);
  first(player1, player2);
  second(player1, player2);
}

void first(Queue<int> original1, Queue<int> original2) {
  final player1 = Queue.of(original1), player2 = Queue.of(original2);
  while (player1.isNotEmpty && player2.isNotEmpty) {
    final card1 = player1.removeFirst(), card2 = player2.removeFirst();
    if (card1 > card2) {
      player1.addAll([card1, card2]);
    } else {
      player2.addAll([card2, card1]);
    }
  }
  print(score(player1.isEmpty ? player2 : player1));
}

void second(Queue<int> original1, Queue<int> original2) {
  final player1 = Queue.of(original1), player2 = Queue.of(original2);
  final winner = recursiveCombat(player1, player2);
  print(score(winner ? player1 : player2));
}

bool recursiveCombat(Queue<int> player1, Queue<int> player2) {
  final previousRounds = <String>{};
  while (player1.isNotEmpty && player2.isNotEmpty) {
    final roundString = '${player1.join(',')}-${player2.join(',')}';
    if (previousRounds.contains(roundString)) return true;
    previousRounds.add(roundString);
    final card1 = player1.removeFirst(), card2 = player2.removeFirst();
    if (player1.length >= card1 && player2.length >= card2) {
      if (recursiveCombat(Queue.of(player1.take(card1)), Queue.of(player2.take(card2)))) {
        player1.addAll([card1, card2]);
      } else {
        player2.addAll([card2, card1]);
      }
    } else if (card1 > card2) {
      player1.addAll([card1, card2]);
    } else {
      player2.addAll([card2, card1]);
    }
  }
  return player1.isNotEmpty;
}

int score(Queue<int> cards) {
  int i = 1;
  final score = cards.toList().reversed.fold<int>(0, (previousValue, element) => previousValue + element * i++);
  return score;
}
