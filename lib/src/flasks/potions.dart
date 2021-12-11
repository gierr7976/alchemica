part of alchemica.flasks;

@immutable
abstract class Potion {
  const Potion();
}

class UnderbrewedPotion extends Potion {
  const UnderbrewedPotion();
}

abstract class BrewedPotion extends Potion {
  const BrewedPotion();
}

class PoisonedPotion extends Potion {
  final Explosion poisoner;

  const PoisonedPotion(this.poisoner);
}
