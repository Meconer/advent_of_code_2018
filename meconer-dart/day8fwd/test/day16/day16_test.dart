import 'package:day8fwd/day16/day16.dart';
import 'package:test/test.dart';

void main() {
  test('addr', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("addr", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 11]), true);
  });

  test('addi', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("addi", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 6]), true);
  });

  test('mulr', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("mulr", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 28]), true);
  });

  test('muli', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("muli", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 8]), true);
  });

  test('banr', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("banr", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 4]), true);
  });

  test('bani', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 15, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("bani", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 4]), true);
  });

  test('borr', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 11, 1];
    cpu.doInstrNamed("borr", instructions);
    expect(cpu.compareRegsWith([3, 4, 11, 15]), true);
  });

  test('bori', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 11, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("bori", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 15]), true);
  });

  test('setr', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("setr", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 4]), true);
  });

  test('seti', () {
    final cpu = Cpu();
    List<int> instructions = [0, 5, 15, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("seti", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 5]), true);
  });

  test('gtir', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("gtir", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 0]), true);

    instructions = [0, 5, 1, 3];
    cpu.regs = [3, 4, 2, 1];
    cpu.doInstrNamed("gtir", instructions);
    expect(cpu.compareRegsWith([3, 4, 2, 1]), true);
  });

  test('gtri', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 15, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("gtri", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 0]), true);

    instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("gtri", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 1]), true);
  });

  test('gtrr', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 7, 1];
    cpu.doInstrNamed("gtrr", instructions);
    expect(cpu.compareRegsWith([3, 4, 7, 0]), true);

    instructions = [0, 1, 2, 3];
    cpu.regs = [3, 5, 3, 1];
    cpu.doInstrNamed("gtrr", instructions);
    expect(cpu.compareRegsWith([3, 5, 3, 1]), true);
  });

  test('eqir', () {
    final cpu = Cpu();
    List<int> instructions = [0, 7, 2, 3];
    cpu.regs = [3, 2, 7, 1];
    cpu.doInstrNamed("eqir", instructions);
    expect(cpu.compareRegsWith([3, 2, 7, 1]), true);

    instructions = [0, 7, 2, 3];
    cpu.regs = [3, 2, 5, 1];
    cpu.doInstrNamed("eqir", instructions);
    expect(cpu.compareRegsWith([3, 2, 5, 0]), true);
  });

  test('eqri', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 2, 7, 1];
    cpu.doInstrNamed("eqri", instructions);
    expect(cpu.compareRegsWith([3, 2, 7, 1]), true);

    instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 5, 1];
    cpu.doInstrNamed("eqri", instructions);
    expect(cpu.compareRegsWith([3, 4, 5, 0]), true);
  });

  test('eqrr', () {
    final cpu = Cpu();
    List<int> instructions = [0, 1, 2, 3];
    cpu.regs = [3, 2, 7, 1];
    cpu.doInstrNamed("eqrr", instructions);
    expect(cpu.compareRegsWith([3, 2, 7, 0]), true);

    instructions = [0, 1, 2, 3];
    cpu.regs = [3, 4, 4, 1];
    cpu.doInstrNamed("eqrr", instructions);
    expect(cpu.compareRegsWith([3, 4, 4, 1]), true);
  });
}
