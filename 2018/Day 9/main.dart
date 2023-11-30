import 'dart:math';

import 'package:double_linked_list/double_linked_list.dart';

void main() {
  getMaxScoreLinkedList(478, 71240);
  getMaxScoreLinkedList(478, 7124000);
}

void getMaxScore(int numberOfPlayers, int numberOfMarbles) {
  final playerScores = List.filled(numberOfPlayers, 0);
  int currentPlayer = 0;

  final circle = [0];
  int currentMarbleIndex = 0;

  for (int nextMarble = 1; nextMarble <= numberOfMarbles; ++nextMarble) {
    if (nextMarble % 23 == 0) {
      playerScores[currentPlayer] += nextMarble;
      final removedMarbleIndex = (currentMarbleIndex - 7) % circle.length;
      playerScores[currentPlayer] += circle.removeAt(removedMarbleIndex);
      currentMarbleIndex = removedMarbleIndex;
    } else {
      final nextMarbleIndex = (currentMarbleIndex + 1) % circle.length + 1;
      circle.insert(nextMarbleIndex, nextMarble);
      currentMarbleIndex = nextMarbleIndex;
    }
    currentPlayer = (currentPlayer + 1) % numberOfPlayers;
    // if (nextMarble % 1000 == 0) print(nextMarble ~/ 1000);
    // print(circle.join(' '));
  }
  print(playerScores.reduce(max));
}

void getMaxScoreLinkedList(int numberOfPlayers, int numberOfMarbles) {
  final playerScores = List.filled(numberOfPlayers, 0);
  int currentPlayer = 0;

  final circle = DoubleLinkedList.fromIterable([0]);
  Node<int> currentMarble = circle.first;

  for (int nextMarbleValue = 1; nextMarbleValue <= numberOfMarbles; ++nextMarbleValue) {
    if (nextMarbleValue % 23 == 0) {
      playerScores[currentPlayer] += nextMarbleValue;
      Node<int> removedMarble = currentMarble;
      for (int i = 0; i < 7; ++i) {
        removedMarble = removedMarble.previous;
        if (removedMarble.isBegin) removedMarble = circle.last;
      }
      playerScores[currentPlayer] += removedMarble.content;
      currentMarble = removedMarble.next.isEnd ? circle.first : removedMarble.next;
      removedMarble.remove();
    } else {
      final nextMarble = currentMarble.next.isEnd ? circle.first : currentMarble.next;
      currentMarble = nextMarble.insertAfter(nextMarbleValue);
    }
    currentPlayer = (currentPlayer + 1) % numberOfPlayers;
    // if (nextMarbleValue % 1000 == 0) print(nextMarbleValue ~/ 1000);
    // print(circle);
  }
  print(playerScores.reduce(max));
}
