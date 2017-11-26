
import 'dart:math';


class DiceRoller {
  final Random random;

  DiceRoller.secure() : this(new Random.secure());

  DiceRoller(this.random);

  int roll(int ndice, int nsides) {
    var sum = 0;
    for (int i = 0; i < ndice; i++) {
      sum += random.nextInt(nsides) + 1; // nextInt is zero-inclusive, add 1 so it's like dice.
    }
    return sum;
  }
}