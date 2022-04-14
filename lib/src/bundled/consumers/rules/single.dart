part of alchemica.bundled.consumers;

class SingleRule<P extends Potion> extends Rule {
  final VialBuilder<P> builder;
  final VialBuilder? fallback;

  SingleRule({
    required this.builder,
    this.fallback,
  });

  @override
  Vial<Potion?> map(BuildContext context, Potion potion) {
    if (potion is P) return builder(context, potion);

    return fallback?.call(context, potion) ?? VoidVial(potion: potion);
  }
}

class VoidVial extends Vial {
  const VoidVial({Key? key, required Potion? potion})
      : super(
          key: key,
          potion: potion,
        );

  @override
  Widget build(BuildContext context) => SizedBox();
}
