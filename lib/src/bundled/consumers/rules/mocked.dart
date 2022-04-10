part of alchemica.bundled.consumers;

class MockedRule<B extends BrewedPotion> extends Rule {
  final VialBuilder<B?> builder;
  final VialBuilder<PoisonedPotion> poisoned;

  MockedRule({
    required this.builder,
    required this.poisoned,
  });

  @override
  Vial<Potion?> map(BuildContext context, Potion potion) {
    if (potion is B) return builder(context, potion);

    if (potion is UnderbrewedPotion) return builder(context, null);

    if (potion is PoisonedPotion) return poisoned(context, potion);

    return onUnknown(context, potion);
  }
}
