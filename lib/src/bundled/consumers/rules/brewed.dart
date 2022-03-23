part of alchemica.bundled.consumers;

class BrewedRule<B extends BrewedPotion> extends Rule {
  final VialBuilder<B> brewed;
  final VialBuilder<UnderbrewedPotion> underbrewed;
  final VialBuilder<PoisonedPotion> poisoned;

  BrewedRule({
    required this.brewed,
    required this.underbrewed,
    required this.poisoned,
  });

  @override
  Vial<Potion?> map(BuildContext context, Potion potion) {
    if (potion is B) return brewed(context, potion);

    if (potion is UnderbrewedPotion) return underbrewed(context, potion);

    if (potion is PoisonedPotion) return poisoned(context, potion);

    return onUnknown(context, potion);
  }
}
