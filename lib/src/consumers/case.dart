part of alchemica.consumers;

class PotionCase<R extends Recipe, F extends Flask> extends StatelessWidget {
  final AlchemicaCondition? buildWhen;
  final AlchemicaWidgetBuilder<UnderbrewedPotion> underbrewed;
  final AlchemicaWidgetBuilder<BrewedPotion> brewed;
  final AlchemicaWidgetBuilder<PoisonedPotion> poisoned;

  const PotionCase({
    Key? key,
    required this.underbrewed,
    required this.brewed,
    required this.poisoned,
    this.buildWhen,
  }) : super(key: key);

  F _getFlask(BuildContext context) {
    F? flask = Lab.of(context).find<R, F>();

    if (flask is F) return flask;
    throw ArgumentError('There is no applicable $F');
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<F, Potion>(
        bloc: _getFlask(context),
        buildWhen: buildWhen,
        builder: _mapper,
      );

  Widget _mapper(BuildContext context, Potion potion) {
    if (potion is UnderbrewedPotion) return underbrewed(context, potion);

    if (potion is BrewedPotion) return brewed(context, potion);

    if (potion is PoisonedPotion) return poisoned(context, potion);

    throw UnimplementedError('Unknown potion type: ${potion.runtimeType}');
  }
}
