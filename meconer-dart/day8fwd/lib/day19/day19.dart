import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 19});

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
  final program = problem.getInput();
  String line = program.removeAt(0);
  int ipRegister = int.parse(line.split(' ')[1]);
  final cpu = Cpu(ipRegister);
  while (cpu.regs[ipRegister] < program.length) {
    line = program[cpu.regs[ipRegister]];

    cpu.doInstrNamed(line.split(' ')[0],
        line.split(' ').sublist(1).map((e) => int.parse(e)).toList());
    cpu.regs[ipRegister]++;
  }

  return cpu.regs[0];
}

class Cpu {
  List<int> regs = [0, 0, 0, 0, 0, 0];
  int ipRegister;

  Cpu(this.ipRegister);

  void doInstrNo(int instrNo, List<int> params) {
    switch (instrNo) {
      case 0:
        addr(params);
        break;
      case 1:
        addi(params);
        break;
      case 2:
        mulr(params);
        break;
      case 3:
        muli(params);
        break;
      case 4:
        banr(params);
        break;
      case 5:
        bani(params);
        break;
      case 6:
        borr(params);
        break;
      case 7:
        bori(params);
        break;
      case 8:
        setr(params);
        break;
      case 9:
        seti(params);
        break;
      case 10:
        gtir(params);
        break;
      case 11:
        gtri(params);
        break;
      case 12:
        gtrr(params);
        break;
      case 13:
        eqir(params);
        break;
      case 14:
        eqri(params);
        break;
      case 15:
        eqrr(params);
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

  void doInstrNamed(String name, List<int> params) {
    if (!instrMap.containsKey(name)) {
      throw Exception('No instruction with that name');
    }
    int instrNo = instrMap[name]!;
    doInstrNo(instrNo, params);
  }

  void addr(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] + regs[instructions[1]];
  }

  void addi(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] + instructions[1];
  }

  void mulr(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] * regs[instructions[1]];
  }

  void muli(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] * instructions[1];
  }

  void banr(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] & regs[instructions[1]];
  }

  void bani(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] & instructions[1];
  }

  void borr(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] | regs[instructions[1]];
  }

  void bori(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] | instructions[1];
  }

  void setr(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]];
  }

  void seti(List<int> instructions) {
    regs[instructions[2]] = instructions[0];
  }

  void gtir(List<int> instructions) {
    regs[instructions[2]] = instructions[0] > regs[instructions[1]] ? 1 : 0;
  }

  void gtri(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] > instructions[1] ? 1 : 0;
  }

  void gtrr(List<int> instructions) {
    regs[instructions[2]] =
        regs[instructions[0]] > regs[instructions[1]] ? 1 : 0;
  }

  void eqir(List<int> instructions) {
    regs[instructions[2]] = instructions[0] == regs[instructions[1]] ? 1 : 0;
  }

  void eqri(List<int> instructions) {
    regs[instructions[2]] = regs[instructions[0]] == instructions[1] ? 1 : 0;
  }

  void eqrr(List<int> instructions) {
    regs[instructions[2]] =
        regs[instructions[0]] == regs[instructions[1]] ? 1 : 0;
  }

  bool compareRegsWith(List<int> registersAfter) {
    for (int i = 0; i < regs.length; i++) {
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
  final program = problem.getInput();
  String line = program.removeAt(0);
  int ipRegister = int.parse(line.split(' ')[1]);
  final cpu = Cpu(ipRegister);
  cpu.regs[0] = 1;
  while (cpu.regs[ipRegister] < program.length) {
    line = program[cpu.regs[ipRegister]];

    cpu.doInstrNamed(line.split(' ')[0],
        line.split(' ').sublist(1).map((e) => int.parse(e)).toList());
    cpu.regs[ipRegister]++;
  }

  return cpu.regs[0];
}
