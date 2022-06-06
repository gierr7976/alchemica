part of alchemica.bundled.consumers;

class SingleRule<P extends Potion> extends Rule {
  final PotionWidgetBuilder<P> builder;
  final PotionWidgetBuilder? fallback;

  SingleRule({
    required this.builder,
    this.fallback,
  });

  @override
  Widget map(BuildContext context, Potion potion) {
    if (potion is P) return builder(context, potion);

    return unknown(context, potion);
  }

  @override
  Widget unknown(BuildContext context, Potion potion) =>
      fallback?.call(context, potion) ?? SizedBox();
}
