import 'dart:io';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = true, this.dayNo = 14});

  int getInput() {
    int serialNo = (isExample ? 18 : 8979);
    return serialNo;
  }
}

Problem problem = Problem(isExample: true);

class CircleNode {
  CircleNode? next;
  CircleNode? prev;
  int value;
  CircleNode(this.value) {
    next = this;
    prev = this;
  }

  CircleNode add(int value) {
    final newNode = CircleNode(value);
    newNode.next = next;
    newNode.prev = this;
    next!.prev = newNode;
    next = newNode;
    return newNode;
  }

  CircleNode moveRight(int steps) {
    var node = this;
    for (int i = 0; i < steps; i++) {
      node = node.next!;
    }
    return node;
  }

  CircleNode moveLeft(int steps) {
    var node = this;
    for (int i = 0; i < steps; i++) {
      node = node.prev!;
    }
    return node;
  }

  (CircleNode, int) remove() {
    prev!.next = next;
    next!.prev = prev;
    return (next!, value);
  }

  printCircle(CircleNode startNode, CircleNode endNode) {
    CircleNode node = startNode;
    while (node != endNode) {
      stdout.write('${node.value} ');
      node = node.next!;
    }
    stdout.write('${node.value} ');
    print("");
  }
}

class Board {
  late CircleNode startNode;
  late CircleNode endNode;
  late CircleNode elfA;
  late CircleNode elfB;
  int nodeCount = 0;
  String lastCorrectSeq = "";

  Board() {
    startNode = CircleNode(3);
    elfA = startNode;
    elfB = elfA.add(7);
    endNode = elfB;
    nodeCount = 2;
  }

  String makeRecipes(int noOfRecipes) {
    while (nodeCount < noOfRecipes + 10) {
      addRecipes(elfA.value + elfB.value);
      elfA = elfA.moveRight(elfA.value + 1);
      elfB = elfB.moveRight(elfB.value + 1);
      // startNode.printCircle(startNode, endNode);
    }
    CircleNode node = endNode;
    for (int i = 0; i < 9; i++) {
      node = node.prev!;
    }
    String s = "";
    for (int i = 0; i < 10; i++) {
      s += "${node.value}";
      node = node.next!;
    }
    return s;
  }

  String addRecipes(int rVal) {
    String s;
    if (rVal >= 10) {
      int first = rVal ~/ 10;
      endNode = endNode.add(first);
      int second = rVal % 10;
      endNode = endNode.add(second);
      nodeCount += 2;
      s = "$first$second";
    } else {
      endNode = endNode.add(rVal);
      s = "$rVal";
      nodeCount++;
    }
    return s;
  }
}

String resultP1() {
  final board = Board();
  int recCount = 598701;
  final result = board.makeRecipes(recCount);
  return result;
}

List<int> recepies = [3, 7];
int elfA = 0;
int elfB = 1;
int nodeCountP2 = 2;

List<int> addRecipesP2(List<int> vals) {
  int n = vals[0] + vals[1];
  List<int> r = [];
  if (n >= 10) {
    int first = n ~/ 10;
    recepies.add(first);
    int second = n % 10;
    recepies.add(second);
    r = [first, second];
    nodeCountP2 += 2;
  } else {
    r = [n];
    recepies.add(n);

    nodeCountP2++;
  }
  return r;
}

int makeRecipesP2(List<int> wantedRecepy) {
  bool ready = false;
  List<int> correctNumbers = [];
  elfA = 0;
  elfB = 1;
  recepies = [3, 7];
  nodeCountP2 = 2;

  while (!ready) {
    final nums = addRecipesP2([recepies[elfA], recepies[elfB]]);
    correctNumbers = checkNumsP2(correctNumbers, nums, wantedRecepy);
    elfA = (elfA + recepies[elfA] + 1) % recepies.length;
    elfB = (elfB + recepies[elfB] + 1) % recepies.length;
    ready = correctNumbers.length >= wantedRecepy.length;
    // if (recepies.length % 10000 == 0) print(recepies.length);
  }

  return nodeCountP2 - correctNumbers.length;
}

List<int> checkNumsP2(
    List<int> soFar, List<int> newNums, List<int> wantedRecepy) {
  bool ok = true;
  for (int idx = 0; idx < newNums.length; idx++) {
    if (soFar.length + idx < wantedRecepy.length) {
      if (wantedRecepy[soFar.length + idx] != newNums[idx]) {
        ok = false;
      }
    }
  }
  if (ok) {
    soFar.addAll(newNums);

    return soFar;
  }
  if (newNums.length == 1) {
    if (newNums[0] == wantedRecepy[0]) {
      return newNums;
    }
  } else {
    if (newNums[0] == wantedRecepy[0] && newNums[1] == wantedRecepy[1]) {
      return newNums;
    }
    if (newNums[1] == wantedRecepy[0]) {
      return [newNums[1]];
    }
  }
  return [];
}

int resultP2() {
  List<int> wantedRecepy = [5, 9, 8, 7, 0, 1];
  // List<int> wantedRecepy = [1, 4, 7, 0, 6, 1];
  assert(makeRecipesP2([5, 1, 5, 8, 9]) == 9);
  assert(makeRecipesP2([0, 1, 2, 4, 5]) == 5);
  assert(makeRecipesP2([9, 2, 5, 1, 0]) == 18);
  assert(makeRecipesP2([5, 9, 4, 1, 4]) == 2018);
  int result = makeRecipesP2(wantedRecepy);
  return result;
}
