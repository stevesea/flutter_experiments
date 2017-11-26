import 'package:petitparser/petitparser.dart';
import 'dice_roller.dart';

import 'dart:math' as math;

class DiceParser {
  DiceRoller _roller;
  Parser parser;
  Parser evaluator;

  Parser build({attachAction: true}) {
    var action = attachAction ? (func) => func : (func) => null;
    var root = failure().settable();
    var builder = new ExpressionBuilder();
    builder.group()
      ..primitive(char('(').trim().seq(root).seq(char(')').trim()).pick(1))
      ..primitive(digit().plus().seq(char('.').seq(digit().plus()).optional())
          .flatten().trim().map((a) => double.parse(a)));
    builder.group()
      ..prefix(char('-').trim(), action((op, a) => -a));
    builder.group()
      ..postfix(string('++').trim(), action((a, op) => ++a))
      ..postfix(string('--').trim(), action((a, op) => --a));
    builder.group()
      ..right(char('^').trim(), action((a, op, b) => math.pow(a, b)));
    builder.group()
      ..left(char('*').trim(), action((a, op, b) => a * b))
      ..left(char('/').trim(), action((a, op, b) => a / b));
    builder.group()
      ..left(char('+').trim(), action((a, op, b) => a + b))
      ..left(char('-').trim(), action((a, op, b) => a - b));
    root.set(builder.build());
    return root.end();
  }

  DiceParser(DiceRoller roller) {
    if (roller == null)
      _roller = new DiceRoller.secure();
    else
      _roller = roller;

    parser = build(attachAction: false);
    evaluator = build(attachAction: true);
  }
}
