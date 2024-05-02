import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 18});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

enum SpotMtrl { ground, lumberyard, trees }

class Board {
  List<List<SpotMtrl>> grid = [];
  late int width;
  late int height;

  Board(List<String> input) {
    for (final line in input) {
      List<SpotMtrl> gridLine = line.split('').map((e) {
        switch (e) {
          case '.':
            return SpotMtrl.ground;
          case '#':
            return SpotMtrl.lumberyard;
          case '|':
            return SpotMtrl.trees;
          default:
            return SpotMtrl.ground;
        }
      }).toList();
      grid.add(gridLine);
    }
    height = grid.length;
    width = grid[0].length;
  }

  void evolve() {
    List<List<SpotMtrl>> newGrid = [];
    for (int row = 0; row < height; row++) {
      List<SpotMtrl> newGridLine = [];
      for (int col = 0; col < width; col++) {
        SpotMtrl currentMtrl = grid[row][col];

        int treeCount = countNeighbouringMtrl(row, col, SpotMtrl.trees);
        int lyCount = countNeighbouringMtrl(row, col, SpotMtrl.lumberyard);
        // An open acre will become filled with trees if three or more
        // adjacent acres contained trees. Otherwise, nothing happens.
        if (currentMtrl == SpotMtrl.ground) {
          newGridLine.add(treeCount >= 3 ? SpotMtrl.trees : currentMtrl);
        }

        // An acre filled with trees will become a lumberyard if
        // three or more adjacent acres were lumberyards. Otherwise,
        // nothing happens.
        if (currentMtrl == SpotMtrl.trees) {
          newGridLine.add(lyCount >= 3 ? SpotMtrl.lumberyard : currentMtrl);
        }

        // An acre containing a lumberyard will remain a lumberyard if it was
        // adjacent to at least one other lumberyard and at least one acre
        // containing trees. Otherwise, it becomes open.
        if (currentMtrl == SpotMtrl.lumberyard) {
          newGridLine.add(lyCount >= 1 && treeCount >= 1
              ? SpotMtrl.lumberyard
              : SpotMtrl.ground);
        }
      }
      newGrid.add(newGridLine);
    }
    grid = newGrid;
  }

  void printBoard() {
    print("Board");
    for (int row = 0; row < height; row++) {
      String lineToPrint = "";
      for (int col = 0; col < width; col++) {
        lineToPrint += switch (grid[row][col]) {
          SpotMtrl.ground => '.',
          SpotMtrl.lumberyard => '#',
          SpotMtrl.trees => '|',
        };
        continue;
      }
      print(lineToPrint);
    }
    print("");
  }

  int countNeighbouringMtrl(int row, int col, SpotMtrl mtrl) {
    int count = 0;
    for (int dr = -1; dr <= 1; dr++) {
      if (row + dr < 0 || row + dr >= height) continue;
      for (int dc = -1; dc <= 1; dc++) {
        if (dc == 0 && dr == 0) continue;
        if (col + dc < 0 || col + dc >= width) continue;
        count += grid[row + dr][col + dc] == mtrl ? 1 : 0;
      }
    }
    return count;
  }

  int count(SpotMtrl mtrl) {
    int count = 0;
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        count += grid[row][col] == mtrl ? 1 : 0;
      }
    }
    return count;
  }
}

int resultP1() {
  Board board = Board(problem.getInput());
  // board.printBoard();
  for (int time = 1; time <= 10; time++) {
    board.evolve();
    // print("Time : $time");
    // board.printBoard();
  }
  int treesCount = board.count(SpotMtrl.trees);
  int lyCount = board.count(SpotMtrl.lumberyard);
  return treesCount * lyCount;
}

int resultP2() {
  Board board = Board(problem.getInput());
  // board.printBoard();
  Map<(int, int), List<int>> treeLyCount = {};

  for (int time = 1; time <= 1000; time++) {
    board.evolve();

    int treesCount = board.count(SpotMtrl.trees);
    int lyCount = board.count(SpotMtrl.lumberyard);

    final cycle = (treesCount, lyCount);
    if (treeLyCount.containsKey(cycle)) {
      treeLyCount[cycle]!.add(time);
    } else {
      treeLyCount[cycle] = [time];
    }
  }
  int lengthBeforeCycles = treeLyCount.length;
  treeLyCount.removeWhere((key, value) => value.length < 10);
  int cycleLength = treeLyCount.length;
  int totalTime = 1000000000;
  int noOfCycles = (totalTime - lengthBeforeCycles) ~/ cycleLength;
  int startCycle = totalTime - (noOfCycles * cycleLength);
  final result = treeLyCount.entries
      .where((element) => element.value.contains(startCycle))
      .first
      .key;
  return result.$1 * result.$2;
}
