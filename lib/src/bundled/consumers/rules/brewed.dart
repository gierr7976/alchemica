part of alchemica.bundled.consumers;

class BrewedRule<B extends BrewedPotion> extends Rule {
  final PotionWidgetBuilder<B> brewed;
  final PotionWidgetBuilder<UnderbrewedPotion> underbrewed;
  final PotionWidgetBuilder<PoisonedPotion> poisoned;

  BrewedRule({
    required this.brewed,
    required this.underbrewed,
    required this.poisoned,
  });

  @override
  Widget map(BuildContext context, Potion potion) {
    if (potion is B) return brewed(context, potion);

    if (potion is UnderbrewedPotion) return underbrewed(context, potion);

    if (potion is PoisonedPotion) return poisoned(context, potion);

    return unknown(context, potion);
  }
}
