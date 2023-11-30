import 'dart:io';
import 'package:collection/collection.dart';

enum Move {
  rock(1),
  paper(2),
  scissors(3);

  const Move(this.score);

  factory Move.fromString(String source) {
    switch (source.toUpperCase()) {
      case 'A':
        return Move.rock;
      case 'B':
        return Move.paper;
      case 'C':
        return Move.scissors;
      case 'X':
        return Move.rock;
      case 'Y':
        return Move.paper;
      case 'Z':
        return Move.scissors;
    }
    throw Exception();
  }

  final int score;

  Move byOutcome(String outcome) {
    if (outcome == 'X') {
      switch (this) {
        case Move.rock:
          return Move.scissors;
        case Move.paper:
          return Move.rock;
        case Move.scissors:
          return Move.paper;
      }
    }
    if (outcome == 'Y') return this;
    if (outcome == 'Z') {
      switch (this) {
        case Move.rock:
          return Move.paper;
        case Move.paper:
          return Move.scissors;
        case Move.scissors:
          return Move.rock;
      }
    }
    throw Exception();
  }
}

void main() {
  final moves = File('./input.txt').readAsLinesSync();
  totalScoreGuide(moves);
  totalScoreGuideOutcomes(moves);
}

void totalScoreGuide(List<String> moves) {
  final scores = moves
      .map((e) => e.split(' '))
      .map((e) => roundScore(Move.fromString(e[0]), Move.fromString(e[1])));
  print(scores.sum);
}

void totalScoreGuideOutcomes(List<String> moves) {
  final scores = moves.map((e) => e.split(' ')).map((e) =>
      roundScore(Move.fromString(e[0]), Move.fromString(e[0]).byOutcome(e[1])));
  print(scores.sum);
}

int roundScore(Move opponent, Move move) {
  return outcomeScore(opponent, move) + move.score;
}

int outcomeScore(Move opponent, Move move) {
  if (move == Move.rock) {
    if (opponent == Move.rock) return 3;
    if (opponent == Move.paper) return 0;
    if (opponent == Move.scissors) return 6;
  } else if (move == Move.paper) {
    if (opponent == Move.rock) return 6;
    if (opponent == Move.paper) return 3;
    if (opponent == Move.scissors) return 0;
  } else if (move == Move.scissors) {
    if (opponent == Move.rock) return 0;
    if (opponent == Move.paper) return 6;
    if (opponent == Move.scissors) return 3;
  }
  throw Exception();
}
