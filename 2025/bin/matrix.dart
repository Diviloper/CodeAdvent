extension MatrixTransformation<T> on List<List<T>> {
  List<List<T>> rotate() {
    if (isEmpty || length != this[0].length) {
      throw ArgumentError('Matrix must be a non-empty square matrix.');
    }

    List<List<T>> rotatedMatrix = List.generate(
      length,
      (i) => List.generate(length, (j) => this[i][j], growable: false),
      growable: false,
    );

    for (int row = 0; row < length; row++) {
      for (int col = 0; col < length; col++) {
        int newRow = col;

        int newCol = length - 1 - row;

        rotatedMatrix[newRow][newCol] = this[row][col];
      }
    }

    return rotatedMatrix;
  }

  List<List<T>> flipHorizontal() {
    if (isEmpty) return [];

    List<List<T>> flippedMatrix = List.generate(
      length,
      (i) => List.generate(length, (j) => this[i][j], growable: false),
      growable: false,
    );

    for (int row = 0; row < length; row++) {
      for (int col = 0; col < length; col++) {
        int newRow = length - 1 - row;

        flippedMatrix[newRow][col] = this[row][col];
      }
    }
    return flippedMatrix;
  }

  List<List<T>> flipVertical() {
    if (isEmpty) return [];

    List<List<T>> flippedMatrix = List.generate(
      length,
          (i) => List.generate(length, (j) => this[i][j], growable: false),
      growable: false,
    );

    for (int row = 0; row < length; row++) {
      for (int col = 0; col < length; col++) {
        int newCol = length - 1 - col;

        flippedMatrix[row][newCol] = this[row][col];
      }
    }
    return flippedMatrix;
  }

  List<List<T>> flipMainDiagonal() {
    if (isEmpty) return [];

    List<List<T>> flippedMatrix = List.generate(
      length,
          (i) => List.generate(length, (j) => this[i][j], growable: false),
      growable: false,
    );

    for (int row = 0; row < length; row++) {
      for (int col = 0; col < length; col++) {
        // Swap row and column indices
        flippedMatrix[col][row] = this[row][col];
      }
    }
    return flippedMatrix;
  }

  List<List<T>> flipAntiDiagonal() {
    if (isEmpty) return [];

    List<List<T>> flippedMatrix = List.generate(
      length,
          (i) => List.generate(length, (j) => this[i][j], growable: false),
      growable: false,
    );

    for (int row = 0; row < length; row++) {
      for (int col = 0; col < length; col++) {
        int newRow = length - 1 - col;
        int newCol = length - 1 - row;

        flippedMatrix[newRow][newCol] = this[row][col];
      }
    }
    return flippedMatrix;
  }
}
