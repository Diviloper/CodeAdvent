import 'dart:io';

typedef Matrix<T> = List<List<T>>;

void main() {
  Matrix<int> trees = File('./input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map(int.parse).toList())
      .toList();

  numberOfVisibleTrees(trees);
  maxScenicScore(trees);
}

void numberOfVisibleTrees(Matrix<int> trees) {
  int count = 0;
  for (int i = 0; i < trees.length; i++) {
    for (int j = 0; j < trees[i].length; ++j) {
      if (isVisible(trees, i, j)) {
        count++;
      }
    }
  }
  print(count);
}

bool isVisible(Matrix<int> trees, int row, int col) {
  final height = trees[row][col];
  bool visible = true;

  for (int j = 0; j < col; ++j) {
    if (trees[row][j] >= height) visible = false;
  }
  if (visible) return true;
  visible = true;
  for (int j = col + 1; j < trees[row].length; ++j) {
    if (trees[row][j] >= height) visible = false;
  }
  if (visible) return true;
  visible = true;
  for (int i = 0; i < row; ++i) {
    if (trees[i][col] >= height) visible = false;
  }
  if (visible) return true;
  visible = true;
  for (int i = row + 1; i < trees.length; ++i) {
    if (trees[i][col] >= height) visible = false;
  }
  return visible;
}

void maxScenicScore(Matrix<int> trees) {
  int maxScore = 0;
  for (int i = 0; i < trees.length; i++) {
    for (int j = 0; j < trees[i].length; ++j) {
      final score = scenicScore(trees, i, j);
      if (score > maxScore) {
        maxScore = score;
      }
    }
  }
  print(maxScore);
}

int scenicScore(Matrix<int> trees, int row, int col) {
  final scores = [0, 0, 0, 0];
  final height = trees[row][col];
  for (int i = row - 1; i >= 0; --i) {
    scores[0]++;
    if (trees[i][col] >= height) break;
  }
  for (int i = row + 1; i < trees.length; ++i) {
    scores[1]++;
    if (trees[i][col] >= height) break;
  }
  for (int j = col - 1; j >= 0; --j) {
    scores[2]++;
    if (trees[row][j] >= height) break;
  }
  for (int j = col + 1; j < trees[row].length; ++j) {
    scores[3]++;
    if (trees[row][j] >= height) break;
  }

  return scores.reduce((value, element) => value * element);
}
