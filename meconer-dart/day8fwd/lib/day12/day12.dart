import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 12});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

class Spread {
  String pattern;
  String result;
  Spread(this.pattern, this.result);
}

int resultP1() {
  final input = problem.getInput();
  String state = input[0].split("initial state: ")[1];
  state = "....$state";
  final patternStrings = input.sublist(2);
  final spreadings = patternStrings.map((pStr) {
    final parts = pStr.split(" => ");
    return Spread(parts[0], parts[1]);
  }).toList();

  const int noOfGenerations = 20;
  for (int generation = 0; generation < noOfGenerations; generation++) {
    // print("$generation: $state");
    state = evolve(state, spreadings);
  }
  int noOfPlants = countPlants(state);
  // print("$noOfGenerations: $state");
  return noOfPlants;
}

String evolve(String state, List<Spread> spreadings) {
  final stateCopy = '...$state....';
  const subLength = 5;

  String newState = "";
  for (int idx = 0; idx < stateCopy.length - subLength; idx++) {
    final sub = stateCopy.substring(idx, idx + subLength);
    int changeCount = 0;
    for (final spread in spreadings) {
      if (spread.pattern == sub) {
        changeCount++;
        newState = newState + spread.result;
      }
      assert(changeCount < 2);
    }
    if (changeCount == 0) {
      newState = '$newState.';
    }
  }
  return newState.substring(1);
}

int countPlants(String state) {
  int count = 0;
  for (int idx = -4; idx < state.length - 4; idx++) {
    String s = state[idx + 4];
    count += s == "#" ? idx : 0;
  }
  return count;
}

int resultP2() {
  final input = problem.getInput();
  String state = input[0].split("initial state: ")[1];
  state = "....$state";
  final patternStrings = input.sublist(2);
  final spreadings = patternStrings.map((pStr) {
    final parts = pStr.split(" => ");
    return Spread(parts[0], parts[1]);
  }).toList();

  const int noOfGenerations = 1000;
  int lastCount = 0;
  int diff = 0;
  for (int generation = 0; generation < noOfGenerations; generation++) {
    // print("$generation: $state");
    state = evolve(state, spreadings);
    if (generation % 100 == 0) {
      int count = countPlants(state);
      diff = count - lastCount;
      lastCount = count;
      // print("$generation - $count : diff $diff");
    }
  }
  int totalGens = 50000000000;
  int countAt500 = 19422;
  int gensLeft = totalGens - 500;
  int diffPerGen = diff ~/ 100;
  int totalCount = countAt500 + (gensLeft - 1) * diffPerGen;
  return totalCount;
}
