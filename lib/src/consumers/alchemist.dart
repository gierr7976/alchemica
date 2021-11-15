part of consumers;

class Alchemist<F extends Flask, B extends BrewedPotion>
    extends StatelessWidget {
  final DrinkerBuilder<UnderbrewedPotion> underbrewedDrinker;
  final DrinkerBuilder<B> brewedDrinker;
  final DrinkerBuilder<PoisonedPotion> poisonedDrinker;
  final BlocBuilderCondition<Potion>? drinkWhen;

  const Alchemist({
    Key? key,
    required this.underbrewedDrinker,
    required this.brewedDrinker,
    required this.poisonedDrinker,
    this.drinkWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<F, Potion>(
        bloc: Lab.of(context).lookup(),
        buildWhen: drinkWhen ?? (_, __) => true,
        builder: _map,
      );

  Widget _map(BuildContext context, Potion potion) {
    if (potion is B) return brewedDrinker(context, potion);

    if (potion is UnderbrewedPotion) return underbrewedDrinker(context, potion);

    if (potion is PoisonedPotion) return poisonedDrinker(context, potion);

    throw StateError('Unclaimed potion: ${potion.runtimeType}');
  }
}
