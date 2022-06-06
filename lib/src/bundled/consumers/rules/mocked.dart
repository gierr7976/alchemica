part of alchemica.bundled.consumers;

class MockedRule<B extends BrewedPotion> extends Rule {
  final PotionWidgetBuilder<B?> builder;
  final PotionWidgetBuilder<PoisonedPotion> poisoned;

  MockedRule({
    required this.builder,
    required this.poisoned,
  });

  @override
  Widget map(BuildContext context, Potion potion) {
    if (potion is B) return builder(context, potion);

    if (potion is UnderbrewedPotion) return builder(context, null);

    if (potion is PoisonedPotion) return poisoned(context, potion);

    return unknown(context, potion);
  }
}
