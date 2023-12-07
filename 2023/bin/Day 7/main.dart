import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

enum HandType implements Comparable<HandType> {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  threeOfAKind,
  twoPair,
  onePair,
  highCard;

  static HandType getHandType(List<Card> cards) {
    final counts = cards.count;

    final jokers = counts.remove(Card.joker) ?? 0;

    final sortedCounts = counts.values.toList()..sort();
    if (sortedCounts.isEmpty) sortedCounts.add(0);

    sortedCounts.last += jokers;

    switch (sortedCounts) {
      case [5]:
        return HandType.fiveOfAKind;
      case [1, 4]:
        return HandType.fourOfAKind;
      case [2, 3]:
        return HandType.fullHouse;
      case [1, 1, 3]:
        return HandType.threeOfAKind;
      case [1, 2, 2]:
        return HandType.twoPair;
      case [1, 1, 1, 2]:
        return HandType.onePair;
      default:
        return HandType.highCard;
    }
  }

  @override
  int compareTo(HandType other) {
    return other.index.compareTo(index);
  }
}

enum Card implements Comparable<Card> {
  A,
  K,
  Q,
  J,
  T,
  nine,
  eight,
  seven,
  six,
  five,
  four,
  three,
  two,
  joker;

  static Card getCard(String card, [bool joker = false]) {
    switch (card) {
      case 'A':
        return Card.A;
      case 'K':
        return Card.K;
      case 'Q':
        return Card.Q;
      case 'J':
        return joker ? Card.joker : Card.J;
      case 'T':
        return Card.T;
      case '9':
        return Card.nine;
      case '8':
        return Card.eight;
      case '7':
        return Card.seven;
      case '6':
        return Card.six;
      case '5':
        return Card.five;
      case '4':
        return Card.four;
      case '3':
        return Card.three;
      case '2':
        return Card.two;
      default:
        throw Exception('Invalid card: $card');
    }
  }

  @override
  int compareTo(Card other) {
    return other.index.compareTo(index);
  }

  static int compare(Card a, Card b) => a.compareTo(b);
}

class Hand implements Comparable<Hand> {
  final List<Card> hand;
  final HandType type;
  final int bid;

  Hand._(this.hand, this.type, this.bid);

  factory Hand(String hand, int bid, [bool joker = false]) {
    final cards = hand.split('').map((e) => Card.getCard(e, joker)).toList();
    final type = HandType.getHandType(cards);
    return Hand._(cards, type, bid);
  }

  factory Hand.jokers(String hand, int bid) => Hand(hand, bid, true);

  @override
  int compareTo(Hand other) {
    if (type == other.type) {
      return zip(hand, other.hand)
          .zippedMap(Card.compare)
          .firstWhere((e) => e != 0);
    } else {
      return type.compareTo(other.type);
    }
  }
}

void main() {
  final handPairs = File('./bin/Day 7/input.txt')
      .readAsLinesSync()
      .map((e) => e.split(' '))
      .map((e) => (e.first, int.parse(e.last)))
      .toList();

  print(handPairs
      .zippedMap(Hand.new)
      .sorted()
      .indexed
      .zippedMap((i, card) => (i + 1) * card.bid)
      .sum);

  print(handPairs
      .zippedMap(Hand.jokers)
      .sorted()
      .indexed
      .zippedMap((i, card) => (i + 1) * card.bid)
      .sum);
}
