import 'package:petitparser/petitparser.dart';
import 'dice_roller.dart';

class DiceParser {
  DiceRoller _roller;
  Parser parser;

  DiceParser(DiceRoller roller) {
    if (roller == null)
      _roller = new DiceRoller.secure();
    else
      _roller = roller;

    var number = digit().plus().flatten().trim().map(int.parse);

    var dice = number.seq(char('d').trim()).seq(number).map((values) {
      return _roller.roll(values[0], values[2]);
    });

    var numOrDice = number | dice;

    var term = undefined();
    var prod = undefined();
    var prim = undefined();

    term.set(prod.seq(char('+').trim()).seq(term).map((values) {
      return values[0] + values[2];
    }).or(prod));

    prod.set(prim.seq(char('*').trim()).seq(prod).map((values) {
      return values[0] * values[2];
    }).or(prim));

    prim.set(char('(').trim().seq(term).seq(char(')'.trim())).map((values) {
      return values[1];
    }).or(numOrDice));

    parser = term.end();
  }
}
