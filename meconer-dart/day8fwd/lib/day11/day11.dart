import 'dart:math';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = true, this.dayNo = 11});

  int getInput() {
    int serialNo = (isExample ? 18 : 8979);
    return serialNo;
  }
}

Problem problem = Problem(isExample: false);

int powerLevel(int x, int y, int serialNo) {
  int rackId = x + 10;
  int powerLevel = rackId * y;
  powerLevel += serialNo;
  powerLevel *= rackId;

  // Keep the hundreds digit
  powerLevel = (powerLevel % 1000);
  powerLevel = powerLevel ~/ 100;
  powerLevel -= 5;
  return powerLevel;
}

int resultP1() {
  final grid = buildGrid(problem.getInput());
  int x, y, sum;
  (x, y, sum) = findLargest(grid);
  print("$x,$y - sum $sum");
  return 0;
}

(int, int, int) findLargest(List<List<int>> grid) {
  int maxSum = -99999;
  int bestStartX = 0;
  int bestStartY = 0;
  for (int startY = 0; startY < grid.length - 3; startY++) {
    for (int startX = 0; startX < grid[0].length - 3; startX++) {
      int sum = 0;
      for (int ofsY = 0; ofsY < 3; ofsY++) {
        for (int ofsX = 0; ofsX < 3; ofsX++) {
          sum += grid[startY + ofsY][startX + ofsX];
        }
      }
      if (sum > maxSum) {
        maxSum = sum;
        bestStartX = startX;
        bestStartY = startY;
      }
    }
  }
  return (bestStartX + 1, bestStartY + 1, maxSum);
}

(int, int, int) findLargestP2(List<List<int>> grid) {
  int maxSum = -99999;
  int bestStartX = 0;
  int bestStartY = 0;
  int bestGridSize = 0;
  int width = grid[0].length;
  int height = grid.length;
  for (int startY = 0; startY < height; startY++) {
    for (int startX = 0; startX < width; startX++) {
      int maxGridSize = min(height - startY, width - startX);
      maxGridSize = min(20, maxGridSize);
      for (int gridSize = 1; gridSize < maxGridSize; gridSize++) {
        int sum = 0;
        for (int ofsY = 0; ofsY < gridSize; ofsY++) {
          for (int ofsX = 0; ofsX < gridSize; ofsX++) {
            sum += grid[startY + ofsY][startX + ofsX];
          }
        }
        if (sum > maxSum) {
          maxSum = sum;
          bestStartX = startX;
          bestStartY = startY;
          bestGridSize = gridSize;
        }
      }
    }
  }
  return (bestStartX + 1, bestStartY + 1, bestGridSize);
}

List<List<int>> buildGrid(int serialNo) {
  List<List<int>> grid = [];
  for (int y = 1; y <= 300; y++) {
    List<int> gridLine = [];
    for (int x = 1; x <= 300; x++) {
      gridLine.add(powerLevel(x, y, serialNo));
    }
    grid.add(gridLine);
  }
  return grid;
}

int resultP2() {
  final grid = buildGrid(problem.getInput());
  int x, y, gridSize;
  (x, y, gridSize) = findLargestP2(grid);
  print("$x,$y,$gridSize");
  return 0;
}
