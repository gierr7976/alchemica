part of alchemica.consumers;

class Pourer<F extends Flask> extends StatelessWidget {
  static Widget defaultFallback(BuildContext context) => SizedBox();

  final Label? label;
  final List<VialFactory> factories;
  final WidgetBuilder fallback;
  final bool strict;

  F? getFlask(BuildContext context) {
    final LabState lab = Lab.of(context);

    if (strict) return lab.require(label);
    return lab.prefer(label);
  }

  const Pourer({
    Key? key,
    this.label,
    required this.factories,
    this.fallback = defaultFallback,
    this.strict = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final F? flask = getFlask(context);

    if (flask is F)
      return BlocBuilder<FlaskBloc, Potion>(
        bloc: getFlask(context)?.bloc,
        builder: buildWithAppropriate,
      );

    return fallback(context);
  }

  Vial buildWithAppropriate(BuildContext context, Potion potion) {
    for (VialFactory factory in factories)
      if (factory.checkPotion(potion)) return factory(potion);

    throw StateError(
      '''
      Unable to find appropriate VialFactory for $potion!\n
      Maybe you forgot to add this one?
      ''',
    );
  }
}
