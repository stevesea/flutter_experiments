import "package:test/test.dart";
import 'package:mockito/mockito.dart';

import 'dart:math';

import "../lib/dice_parser.dart";
import "../lib/dice_roller.dart";

import 'package:petitparser/petitparser.dart';


class MockRandom extends Mock implements Random {}

void main() {
  var mockRandom = new MockRandom();
  var roller = new DiceRoller(mockRandom);
  var diceParser = new DiceParser(roller);

  when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000)))).thenReturn(1);

  test("dice parser - addition", () {
    var input = "1 + 20";
    expect(diceParser.roll(input), equals(21));
  });
  test("dice parser - subtraction", () {
    var input = "1 - 20";
    expect(diceParser.roll(input), equals(-19));
  });

  test("dice parser - multi", () {
    var input = "3 * 2";
    expect(diceParser.roll(input), equals(6));
  });

  test("dice parser - parens", () {
    var input = "(5 + 6) * 2";
    expect(diceParser.roll(input), equals(22));
  });

  test("dice parser - order of operations", () {
    var input = "5 + 6 * 2";
    expect(diceParser.roll(input), equals(17));
  });

  test("dice parser - simple roll", () {
    var input = "1d6";
    expect(diceParser.roll(input), equals(2));
  });
  test("dice parser - dice pool", () {
    var input = "(4+6)d10";
    expect(diceParser.roll(input), equals(20));
  });

}