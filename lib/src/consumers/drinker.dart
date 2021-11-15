part of consumers;

typedef DrinkerBuilder<P extends Potion> = Widget Function(
    BuildContext context, P potion);

class Drinker<F extends Flask, P extends Potion> extends StatelessWidget {
  final DrinkerBuilder<P> drinker;
  final BlocBuilderCondition<P>? drinkWhen;

  const Drinker({
    Key? key,
    required this.drinker,
    this.drinkWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<F, Potion>(
        bloc: Lab.of(context).lookup(),
        buildWhen: _buildWhen,
        builder: _map,
      );

  Widget _map(BuildContext context, Potion potion) {
    if (potion is P) return drinker(context, potion);

    throw StateError('Incorrect potion: ${potion.runtimeType}');
  }

  bool _buildWhen(Potion previous, Potion current) {
    if (current is! P)
      throw StateError('Incorrect potion: ${current.runtimeType}');
    if (drinkWhen == null) return true;
    if (previous is! P) return true;

    return drinkWhen!(previous, current);
  }
}
