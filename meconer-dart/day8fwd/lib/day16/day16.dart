import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 16});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

List<int> getRegsFromLine(String line) {
  line = line.replaceAll(RegExp(r'\w+: +\['), '').replaceAll(']', '');
  List<int> regs = line.split(', ').map((e) => int.parse(e)).toList();
  return regs;
}

int resultP1() {
  final input = problem.getInput();
  String line = input.removeAt(0);
  int countThreeOrMore = 0;
  while (line.isNotEmpty) {
    final registersBefore = getRegsFromLine(line);
    line = input.removeAt(0);
    final instrs = line.split(' ').map((e) => int.parse(e)).toList();
    line = input.removeAt(0);
    final registersAfter = getRegsFromLine(line);
    int possibleInstrCount =
        countPossibleInstructions(registersBefore, instrs, registersAfter);
    if (possibleInstrCount >= 3) countThreeOrMore++;
    line = input.removeAt(0);
    line = input.removeAt(0);
  }
  return countThreeOrMore;
}

int countPossibleInstructions(
    List<int> registersBefore, List<int> instrs, List<int> registersAfter) {
  final cpu = Cpu();

  int count = 0;
  for (int instrNo = 0; instrNo < 16; instrNo++) {
    for (int i = 0; i < 4; i++) {
      cpu.regs[i] = registersBefore[i];
    }
    // cpu.printRegs();
    final instrName = cpu.instrMap.keys
        .firstWhere((element) => cpu.instrMap[element] == instrNo);
    String s = "Instr: $instrName  ";
    for (final instr in instrs.sublist(1)) {
      s += "$instr, ";
    }
    // print(s);
    cpu.doInstrNo(instrNo, instrs);

    // cpu.printRegs();
    // print("");
    if (cpu.compareRegsWith(registersAfter)) count++;
  }

  return count;
}

class Cpu {
  List<int> regs = [0, 0, 0, 0];

  void doInstrNo(int instrNo, List<int> instruction) {
    switch (instrNo) {
      case 0:
        addr(instruction);
        break;
      case 1:
        addi(instruction);
        break;
      case 2:
        mulr(instruction);
        break;
      case 3:
        muli(instruction);
        break;
      case 4:
        banr(instruction);
        break;
      case 5:
        bani(instruction);
        break;
      case 6:
        borr(instruction);
        break;
      case 7:
        bori(instruction);
        break;
      case 8:
        setr(instruction);
        break;
      case 9:
        seti(instruction);
        break;
      case 10:
        gtir(instruction);
        break;
      case 11:
        gtri(instruction);
        break;
      case 12:
        gtrr(instruction);
        break;
      case 13:
        eqir(instruction);
        break;
      case 14:
        eqri(instruction);
        break;
      case 15:
        eqrr(instruction);
        break;
    }
  }

  Map<String, int> instrMap = {
    'addr': 0,
    'addi': 1,
    'mulr': 2,
    'muli': 3,
    'banr': 4,
    'bani': 5,
    'borr': 6,
    'bori': 7,
    'setr': 8,
    'seti': 9,
    'gtir': 10,
    'gtri': 11,
    'gtrr': 12,
    'eqir': 13,
    'eqri': 14,
    'eqrr': 15,
  };

  void doInstrNamed(String name, List<int> regs) {
    if (!instrMap.containsKey(name)) {
      throw Exception('No instruction with that name');
    }
    regs[0] = instrMap[name]!;
    doInstrNo(regs[0], regs);
  }

  void addr(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] + regs[instructions[2]];
  }

  void addi(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] + instructions[2];
  }

  void mulr(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] * regs[instructions[2]];
  }

  void muli(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] * instructions[2];
  }

  void banr(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] & regs[instructions[2]];
  }

  void bani(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] & instructions[2];
  }

  void borr(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] | regs[instructions[2]];
  }

  void bori(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] | instructions[2];
  }

  void setr(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]];
  }

  void seti(List<int> instructions) {
    regs[instructions[3]] = instructions[1];
  }

  void gtir(List<int> instructions) {
    regs[instructions[3]] = instructions[1] > regs[instructions[2]] ? 1 : 0;
  }

  void gtri(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] > instructions[2] ? 1 : 0;
  }

  void gtrr(List<int> instructions) {
    regs[instructions[3]] =
        regs[instructions[1]] > regs[instructions[2]] ? 1 : 0;
  }

  void eqir(List<int> instructions) {
    regs[instructions[3]] = instructions[1] == regs[instructions[2]] ? 1 : 0;
  }

  void eqri(List<int> instructions) {
    regs[instructions[3]] = regs[instructions[1]] == instructions[2] ? 1 : 0;
  }

  void eqrr(List<int> instructions) {
    regs[instructions[3]] =
        regs[instructions[1]] == regs[instructions[2]] ? 1 : 0;
  }

  bool compareRegsWith(List<int> registersAfter) {
    for (int i = 0; i < 4; i++) {
      if (regs[i] != registersAfter[i]) return false;
    }
    return true;
  }

  void printRegs() {
    String s = "";
    for (var reg in regs) {
      s += "$reg ";
    }
    print("Regs : $s");
  }
}

int resultP2() {
  final input = problem.getInput();
  String line = input.removeAt(0);
  Map<int, Set<int>> possibleInstrMap = {};
  while (line.isNotEmpty) {
    final registersBefore = getRegsFromLine(line);
    line = input.removeAt(0);
    final instrs = line.split(' ').map((e) => int.parse(e)).toList();
    line = input.removeAt(0);
    final registersAfter = getRegsFromLine(line);
    final possibleInstructions =
        getPossibleInstructions(registersBefore, instrs, registersAfter);
    possibleInstrMap[instrs[0]] = possibleInstructions.toSet();
    line = input.removeAt(0);
    line = input.removeAt(0);
  }
  bool ready = false;
  List<int> realInstrMap = List.generate(possibleInstrMap.length, (_) => -1);
  while (!ready) {
    for (int realInstrNo = 0;
        realInstrNo < possibleInstrMap.length;
        realInstrNo++) {
      if (possibleInstrMap[realInstrNo]!.length == 1) {
        realInstrMap[realInstrNo] = possibleInstrMap[realInstrNo]!.first;
        for (final key in possibleInstrMap.keys) {
          possibleInstrMap[key]!
              .removeWhere((instrNo) => instrNo == realInstrMap[realInstrNo]);
        }
      }
    }
    for (int realInstrNo = 0;
        realInstrNo < possibleInstrMap.length;
        realInstrNo++) {
      int countUsed = 0;
      int lastKey = -1;
      for (int mapKey = 0; mapKey < possibleInstrMap.length; mapKey++) {
        if (possibleInstrMap[mapKey]!.contains(realInstrNo)) {
          countUsed++;
          lastKey = mapKey;
        }
      }
      if (countUsed == 1) {
        realInstrMap[lastKey] = realInstrNo;
        for (final key in possibleInstrMap.keys) {
          possibleInstrMap[key]!
              .removeWhere((element) => element == realInstrMap[realInstrNo]);
        }
      }
    }
    ready =
        !possibleInstrMap.values.any((possibleSet) => possibleSet.isNotEmpty);
  }

  // Now we have a map from the instruction code in the program to the
  // instruction number in our emulation
  input.removeAt(0); // Remove the first empty program line
  final cpu = Cpu();
  for (final programLine in input) {
    List<int> instructions =
        programLine.split(' ').map((e) => int.parse(e)).toList();
    int instrNo = realInstrMap[instructions[0]];
    cpu.doInstrNo(instrNo, instructions);
  }
  return cpu.regs[0];
}

List<int> getPossibleInstructions(
    List<int> registersBefore, List<int> instrs, List<int> registersAfter) {
  final cpu = Cpu();

  List<int> validInstructions = [];

  for (int instrNo = 0; instrNo < 16; instrNo++) {
    for (int i = 0; i < 4; i++) {
      cpu.regs[i] = registersBefore[i];
    }
    cpu.doInstrNo(instrNo, instrs);

    // cpu.printRegs();
    // print("");
    if (cpu.compareRegsWith(registersAfter)) validInstructions.add(instrNo);
  }
  return validInstructions;
}
