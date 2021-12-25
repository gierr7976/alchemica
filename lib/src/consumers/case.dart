part of alchemica.consumers;

class PotionCase<R extends Recipe, F extends Flask> extends StatelessWidget
    with FlaskExtractor<R, F> {
  @override
  final Label? label;
  final AlchemicaCondition? buildWhen;
  final AlchemicaWidgetBuilder<UnderbrewedPotion> underbrewed;
  final AlchemicaWidgetBuilder<BrewedPotion> brewed;
  final AlchemicaWidgetBuilder<PoisonedPotion> poisoned;

  const PotionCase({
    Key? key,
    this.label,
    required this.underbrewed,
    required this.brewed,
    required this.poisoned,
    this.buildWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<F, Potion>(
        bloc: extractFlask(context),
        buildWhen: buildWhen,
        builder: mapper,
      );

  @protected
  Widget mapper(BuildContext context, Potion potion) {
    if (potion is UnderbrewedPotion) return underbrewed(context, potion);

    if (potion is BrewedPotion) return brewed(context, potion);

    if (potion is PoisonedPotion) return poisoned(context, potion);

    throw UnimplementedError('Unknown potion type: ${potion.runtimeType}');
  }
}
