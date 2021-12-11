part of alchemica.consumers;

class SelectiveCase<R extends Recipe, F extends Flask, P extends Potion>
    extends StatelessWidget with FlaskExtractor<R, F> {
  @override
  final Label? label;
  final AlchemicaWidgetBuilder<P> builder;
  final AlchemicaWidgetBuilder? fallback;
  final AlchemicaCondition? buildWhen;

  const SelectiveCase({
    Key? key,
    this.label,
    required this.builder,
    this.fallback,
    this.buildWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<F, Potion>(
        bloc: extractFlask(context),
        buildWhen: buildWhen,
        builder: mapper,
      );

  Widget mapper(BuildContext context, Potion potion) {
    if (potion is P) return builder(context, potion);

    return fallback is AlchemicaWidgetBuilder
        ? fallback!(context, potion)
        : SizedBox();
  }
}
